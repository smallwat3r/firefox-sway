#!/usr/bin/env python3
"""Download the latest XPI for an AMO addon using the v5 API.

Reads WEB_EXT_API_KEY and WEB_EXT_API_SECRET from the environment,
constructs a JWT (HS256, stdlib only), queries the AMO versions
endpoint, and saves the XPI to the given output path.

Usage:
    fetch-amo-xpi.py <addon-slug> <output-path>
"""

import base64
import hashlib
import hmac
import json
import os
import sys
import time
import urllib.error
import urllib.request

AMO_API = "https://addons.mozilla.org/api/v5"
TIMEOUT = 30


def b64url(data: bytes) -> str:
    """Return unpadded URL-safe Base64 encoding."""
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode()


def make_jwt(key: str, secret: str) -> str:
    """Build an HS256 JWT accepted by the AMO API."""
    now = int(time.time())
    header = b64url(json.dumps({"alg": "HS256", "typ": "JWT"}).encode())
    payload = b64url(json.dumps({"iss": key, "iat": now, "exp": now + 300}).encode())
    signing_input = f"{header}.{payload}"
    sig = hmac.new(
        secret.encode(),
        signing_input.encode(),
        hashlib.sha256,
    ).digest()
    return f"{signing_input}.{b64url(sig)}"


def api_get(url: str, token: str) -> dict:
    """GET a JSON resource from the AMO API."""
    req = urllib.request.Request(
        url,
        headers={"Authorization": f"JWT {token}"},
    )
    try:
        with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
            return json.loads(resp.read())
    except urllib.error.HTTPError as exc:
        body = exc.read().decode(errors="replace")
        print(f"AMO API error ({exc.code}): {body}", file=sys.stderr)
        raise SystemExit(1)
    except urllib.error.URLError as exc:
        print(f"Network error: {exc.reason}", file=sys.stderr)
        raise SystemExit(1)


def download(url: str, token: str, dest: str) -> None:
    """Download a file, streaming to *dest*."""
    req = urllib.request.Request(
        url,
        headers={"Authorization": f"JWT {token}"},
    )
    try:
        with urllib.request.urlopen(req, timeout=TIMEOUT) as resp, \
             open(dest, "wb") as fp:
            while chunk := resp.read(1 << 16):
                fp.write(chunk)
    except urllib.error.HTTPError as exc:
        print(f"Download failed ({exc.code})", file=sys.stderr)
        raise SystemExit(1)
    except urllib.error.URLError as exc:
        print(f"Network error: {exc.reason}", file=sys.stderr)
        raise SystemExit(1)


def main() -> None:
    if len(sys.argv) != 3:
        print(
            "Usage: fetch-amo-xpi.py"
            " <addon-slug> <output-path>",
            file=sys.stderr,
        )
        raise SystemExit(2)

    slug, output = sys.argv[1], sys.argv[2]

    key = os.environ.get("WEB_EXT_API_KEY", "")
    secret = os.environ.get("WEB_EXT_API_SECRET", "")
    if not key or not secret:
        print(
            "WEB_EXT_API_KEY and WEB_EXT_API_SECRET"
            " must be set",
            file=sys.stderr,
        )
        raise SystemExit(1)

    token = make_jwt(key, secret)

    versions_url = (
        f"{AMO_API}/addons/addon/{slug}"
        f"/versions/?filter=all_with_unlisted"
    )
    data = api_get(versions_url, token)

    results = data.get("results")
    if not results:
        print("No versions found", file=sys.stderr)
        raise SystemExit(1)

    xpi_url = results[0].get("file", {}).get("url")
    if not xpi_url:
        print("No file URL in latest version", file=sys.stderr)
        raise SystemExit(1)

    download(xpi_url, token, output)
    print("Extension installed.")


if __name__ == "__main__":
    main()
