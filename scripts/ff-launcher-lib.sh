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
  [[ -n "$profile" ]] || die "No default profile found"
  echo "$ff_dir/$profile"
}

# FZF keybindings, colors, and base options.
FZF_BIND="ctrl-left:backward-word"
FZF_BIND+=",ctrl-right:forward-word"
FZF_BIND+=",ctrl-bs:backward-kill-word"
FZF_BIND+=",home:first,end:last"

FZF_COLORS="bg:#c0c0c0,fg:#000000"
FZF_COLORS+=",bg+:#000080,fg+:#ffffff"
FZF_COLORS+=",hl:#000080:bold,hl+:#d4aa00"
FZF_COLORS+=",pointer:#000000,prompt:#000000"
FZF_COLORS+=",info:#000000,gutter:#c0c0c0"
FZF_COLORS+=",query:#000000"

FZF_OPTS=(
  --reverse --wrap --tiebreak=index
  --pointer='' --prompt='' --highlight-line
  --no-separator --no-scrollbar
  --info=inline-right
  --color="$FZF_COLORS"
  --bind="$FZF_BIND"
)
