// Open new windows instead of tabs, let sway manage them
user_pref("browser.link.open_newwindow", 2);
user_pref("browser.link.open_newwindow.restriction", 0);
user_pref("browser.link.open_newwindow.override.external", 2);
user_pref("browser.tabs.opentabfor.middleclick", false);

// Auto-enable sideloaded extensions
user_pref("extensions.autoDisableScopes", 0);

// Enable userChrome.css
user_pref(
  "toolkit.legacyUserProfileCustomizations.stylesheets",
  true
);

// Disable unused tab features (tabs are converted to windows
// by the tabs-to-windows extension).
user_pref("browser.tabs.animate", false);
user_pref("browser.tabs.warnOnClose", false);
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.sessionstore.resume_from_crash", false);
