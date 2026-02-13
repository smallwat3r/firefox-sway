# firefox-wm

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

- Hides the tab bar with a `userChrome.css` rule
- Opens new tabs as windows via Firefox preferences (`user.js`)
- Installs an extension (Tabs to Windows) that moves any
  tab created in a multi-tab window into its own window,
  so it is managed by the WM

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
