FIREFOX_DIR := $(HOME)/.mozilla/firefox
SRC_DIR     := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
EXT_DIR     := $(SRC_DIR)extensions/tabs-to-windows
EXT_ID      := {ad9d4d3f-e4f3-4736-9dee-a3be62270429}
AMO_SLUG    := 6164e14e709b4ee5a368
BIN_DIR     := $(HOME)/.local/bin

# Extract the default profile from the first [Install*] section.
PROFILE_DIR := $(FIREFOX_DIR)/$(shell awk -F= ' \
  /^\[Install/ { f=1 } \
  f && /^Default=/ { print $$2; exit } \
' "$(FIREFOX_DIR)/profiles.ini")

.PHONY: install uninstall sign

install:
	@[ -d "$(PROFILE_DIR)" ] || \
	  { echo "No default profile found" >&2; exit 1; }
	mkdir -p "$(PROFILE_DIR)/chrome"
	ln -sfv "$(SRC_DIR)chrome/userChrome.css" \
	  "$(PROFILE_DIR)/chrome/userChrome.css"
	ln -sfv "$(SRC_DIR)user.js" "$(PROFILE_DIR)/user.js"
	@mkdir -p "$(PROFILE_DIR)/extensions"
	@if [ -n "$$WEB_EXT_API_KEY" ] && \
	    [ -n "$$WEB_EXT_API_SECRET" ]; then \
	  python3 "$(SRC_DIR)scripts/fetch-amo-xpi.py" \
	    "$(AMO_SLUG)" \
	    "$(PROFILE_DIR)/extensions/$(EXT_ID).xpi"; \
	else \
	  echo ""; \
	  echo "Set WEB_EXT_API_KEY and" \
	    "WEB_EXT_API_SECRET to install the" \
	    "extension from AMO."; \
	fi
	mkdir -p "$(BIN_DIR)"
	ln -sfv "$(SRC_DIR)scripts/ff-launcher-bookmarks" \
	  "$(BIN_DIR)/ff-launcher-bookmarks"
	ln -sfv "$(SRC_DIR)scripts/ff-launcher-history" \
	  "$(BIN_DIR)/ff-launcher-history"
	ln -sfv "$(SRC_DIR)scripts/ff-launcher-search" \
	  "$(BIN_DIR)/ff-launcher-search"
	@echo ""
	@echo "Done. Restart Firefox to apply changes."

uninstall:
	@[ -d "$(PROFILE_DIR)" ] || \
	  { echo "No default profile found" >&2; exit 1; }
	rm -fv "$(PROFILE_DIR)/chrome/userChrome.css"
	rm -fv "$(PROFILE_DIR)/user.js"
	rm -fv "$(PROFILE_DIR)/extensions/$(EXT_ID).xpi"
	rm -fv "$(BIN_DIR)/ff-launcher-bookmarks"
	rm -fv "$(BIN_DIR)/ff-launcher-history"
	rm -fv "$(BIN_DIR)/ff-launcher-search"
	@echo "Removed."

sign:
	cd "$(EXT_DIR)" && web-ext sign --channel unlisted
