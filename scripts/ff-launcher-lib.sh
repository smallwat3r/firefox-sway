# Shared helpers for ff-launcher scripts.
# Source this file: . "$(dirname "$0")/ff-launcher-lib.sh"

set -euo pipefail

die() { echo "$1" >&2; exit 1; }

require() {
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null || die "$cmd is required"
  done
}

# Resolve the default Firefox profile directory.
ff_profile_dir() {
  local ff_dir="$HOME/.mozilla/firefox"
  [[ -f "$ff_dir/profiles.ini" ]] \
    || die "Firefox profiles.ini not found"
  local profile
  profile=$(awk -F= '
    /^\[Install/ { f=1 }
    f && /^Default=/ { print $2; exit }
  ' "$ff_dir/profiles.ini")
  echo "$ff_dir/$profile"
}

# FZF colors and base options.
FZF_COLORS="bg:#222222,fg:#bbbbbb"
FZF_COLORS+=",bg+:#005577,fg+:#eeeeee"
FZF_COLORS+=",hl:#eeeeee,hl+:#eeeeee"
FZF_COLORS+=",pointer:#eeeeee,prompt:#eeeeee"
FZF_COLORS+=",info:#eeeeee,gutter:#222222"

FZF_OPTS=(
  --reverse --wrap --tiebreak=index
  --pointer='' --highlight-line
  --no-separator --no-scrollbar
  --info=inline-right
  --color="$FZF_COLORS"
)
