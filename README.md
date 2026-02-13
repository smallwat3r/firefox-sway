# firefox-sway

Minimal Firefox configuration for tiling window managers.

The default Firefox tab bar wastes vertical space when a tiling WM
like sway already manages windows. This repo removes the tab bar
entirely and forces every new tab to open as a separate window, so
sway (or any tiling WM) can handle layout, stacking, and switching
natively.

This is my personal setup. It should be safe for anyone to use, but
**back up your Firefox profile first** as it overwrites `user.js` and
`userChrome.css` via symlinks.

## What it does

- Hides the tab bar and bookmark bar with `userChrome.css`
- Opens new tabs as windows via Firefox preferences (`user.js`)
- Installs an extension (Tabs to Windows) that moves any
  tab created in a multi-tab window into its own window,
  so it is managed by the WM
- Provides fzf-based launchers for bookmarks, history,
  and search

## Install

```
make install
```

This symlinks `userChrome.css` and `user.js` into your default
Firefox profile and, optionally, downloads the extension from AMO.

The extension is unlisted on AMO. To sign it under your own
account (one-off), create an AMO account at
https://addons.mozilla.org/developers/, generate API keys, then:

```
export WEB_EXT_API_KEY=...
export WEB_EXT_API_SECRET=...
make sign
```

Once signed, `make install` will download and install the
extension using the same API keys.

Restart Firefox after installing.

## Uninstall

```
make uninstall
```

Removes the symlinks and the extension XPI from your profile.
Restart Firefox after uninstalling.

## Launchers

`make install` symlinks `ff-launcher-bookmarks`,
`ff-launcher-history`, and `ff-launcher-search` into `~/.local/bin`.
All three require `fzf`. Bookmarks and history also
require `sqlite3`.

To use them as popup launchers in sway with foot, create a
foot config for the launcher UI (font, colors, etc.):

```ini
# ~/.config/foot/launcher.ini
[main]
font = MonacoB:size=10, Twemoji:size=10

[cursor]
style = beam

[colors]
foreground = bbbbbb
background = 222222
```

Then add the following to your sway config to start the foot
server, float launcher windows, and bind the keys:

```
# ~/.config/sway/config
exec foot \
  --server=$XDG_RUNTIME_DIR/foot-launcher.sock \
  --config=$HOME/.config/foot/launcher.ini

for_window [title="^launcher$"] \
  floating enable, \
  border pixel 1, \
  sticky enable, \
  move to output current, \
  move position 0 0, \
  focus

set $launcher footclient \
  -s $XDG_RUNTIME_DIR/foot-launcher.sock \
  --title=launcher

bindsym $mod+o exec $launcher -w 9999x400 ff-launcher-history
bindsym $mod+u exec $launcher -w 9999x200 ff-launcher-bookmarks
bindsym $mod+s exec $launcher -w 9999x1 ff-launcher-search

# Assign Firefox to its own workspace with tabbed layout.
assign [app_id="firefox"] workspace number 10
for_window [app_id="firefox"] layout tabbed, urgent enable
```
