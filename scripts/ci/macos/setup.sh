#!/bin/sh -e

STEAM_INSTALL_DIR="$HOME/Library/Application Support/Steam/steamapps/common/Starbound"

# Remove old version files, if any. "|| true" ignores any failures, while "2>/dev/null" silences the error messages.
# It's normal for file-not-found errors to occur here if we're doing a fresh install, or upgrading from a 3.x build.
rm "${STEAM_INSTALL_DIR}/mods/Starbecue*.pak" 2>/dev/null || true
rm "${STEAM_INSTALL_DIR}/mods/starboundSpeciesAnimOverrides*.pak" 2>/dev/null || true
rm "${STEAM_INSTALL_DIR}/mods/SBQ_engine_assets*.pak" 2>/dev/null || true

# add new files
cp -rf osx/* "${STEAM_INSTALL_DIR}/osx"
cp -rf mods/* "${STEAM_INSTALL_DIR}/mods"
cp -rf assets/* "${STEAM_INSTALL_DIR}/assets"

xattr -c "$STEAM_INSTALL_DIR/osx/Starbound.app"
