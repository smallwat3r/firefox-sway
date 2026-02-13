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

// Disable sidebar
user_pref("sidebar.revamp", false);
user_pref("sidebar.verticalTabs", false);
user_pref("browser.toolbars.bookmarks.visibility", "never");

// Simplify the URL bar (launchers handle search, bookmarks,
// and history externally).
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.trending", false);
user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.urlbar.shortcuts.bookmarks", false);
user_pref("browser.urlbar.shortcuts.history", false);
user_pref("browser.urlbar.shortcuts.tabs", false);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
