#!/usr/bin/env python3
"""Download the latest XPI for an AMO addon.

Usage: fetch-amo-xpi.py <addon-slug> <output-path>

Reads WEB_EXT_API_KEY and WEB_EXT_API_SECRET from env,
builds a JWT (HS256), and fetches the XPI via the v5 API.
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


def die(msg):
    print(msg, file=sys.stderr)
    raise SystemExit(1)


def b64url(data):
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode()


def make_jwt(key, secret):
    now = int(time.time())
    hdr = b64url(json.dumps({"alg": "HS256", "typ": "JWT"}).encode())
    pay = b64url(json.dumps({"iss": key, "iat": now, "exp": now + 300}).encode())
    sig = hmac.new(secret.encode(), f"{hdr}.{pay}".encode(), hashlib.sha256).digest()
    return f"{hdr}.{pay}.{b64url(sig)}"


def fetch(url, token):
    req = urllib.request.Request(url, headers={"Authorization": f"JWT {token}"})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            return r.read()
    except urllib.error.HTTPError as e:
        die(f"HTTP {e.code}: {e.read().decode('utf-8', 'replace')}")
    except urllib.error.URLError as e:
        die(f"Network error: {e.reason}")


def main():
    if len(sys.argv) != 3:
        die("Usage: fetch-amo-xpi.py <slug> <output>")

    slug, output = sys.argv[1], sys.argv[2]

    key = os.environ.get("WEB_EXT_API_KEY", "")
    secret = os.environ.get("WEB_EXT_API_SECRET", "")
    if not key or not secret:
        die("WEB_EXT_API_KEY and WEB_EXT_API_SECRET must be set")

    token = make_jwt(key, secret)

    url = f"{AMO_API}/addons/addon/{slug}/versions/?filter=all_with_unlisted"
    data = json.loads(fetch(url, token))

    results = data.get("results")
    if not results:
        die("No versions found")

    xpi_url = results[0].get("file", {}).get("url")
    if not xpi_url:
        die("No file URL in latest version")

    with open(output, "wb") as f:
        f.write(fetch(xpi_url, token))
    print("Extension installed.")


if __name__ == "__main__":
    main()
