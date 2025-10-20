#!/bin/sh -e

STEAM_LIBPATHS_CONFIG="$HOME/.steam/steam/config/libraryfolders.vdf"
DID_FIND_STARBOUND=false

if [ ! -z "${1}" ]; then
	STARBOUND_INSTALL_PATH="${1}"
fi

if [ -z "${STARBOUND_INSTALL_PATH}" ]; then
    # Extract library paths and Starbound app id
    STEAM_LIBPATHS="$(
        cat ${STEAM_LIBPATHS_CONFIG} | \
        tr -s "\t" | \
        grep -E -w '^((\t"path"\t"[^"]+")|(\t"211820"\t"[0-9]+"))' | \
        sed 's/\t"path"\t//g; s/\t"211820"\t".*/:211820/g; s/"//g'
    )"

    LAST_PATH=
    CUR_PATH=

    # Iterate through STEAM_LIBPATHS and look for a path/appid pair.
    while read -r CUR_PATH; do
        if [ "$CUR_PATH" == ":211820" ]; then
            DID_FIND_STARBOUND=true
            STARBOUND_INSTALL_PATH="${LAST_PATH}/steamapps/common/Starbound"
            break
        fi

        LAST_PATH="${CUR_PATH}"
    done <<< "${STEAM_LIBPATHS}"

    # If we didn't find the path, bail out and tell the user how they can workaround this if needed.
    if [ $DID_FIND_STARBOUND == false ]; then
        echo "Couldn't find your Starbound installation!"
        echo
        echo "Please ensure that your SteamLibrary is setup correctly!"
        echo "Alternatively, you may manually specify a Starbound installation path by re-running this script like so:"
        echo $'\t' "./${0}" "/full/path/to/starbound/root/dir"
        exit 1
    fi
fi

if [ $DID_FIND_STARBOUND == true ]; then
    echo "Automatically found your Starbound installation: ${STARBOUND_INSTALL_PATH}"
else
    echo "Using manually-specified Starbound installation: ${STARBOUND_INSTALL_PATH}"
fi

# Make sure whatever path we're using is a valid Starbound installation.
if [ ! -f "${STARBOUND_INSTALL_PATH}/linux/starbound" ]; then
    echo "The Starbound installation path does not appear to be valid (missing game executable)!"
    echo

    if [ $DID_FIND_STARBOUND == true ]; then
        echo "You can manually specify your Starbound installation path instead by re-running this script like so:"
        echo $'\t' "./${0}" "/full/path/to/starbound/root/dir"
    else
        echo "Please double check that STARBOUND_INSTALL_PATH points towards the root directory of your Starbound installation."
        echo "If the path contains any spaces or brackets, please make sure to include quotes around the path."
    fi
    exit 1
fi

# Everything checks out; let's get installing!
STEAM_INSTALL_DIR="${STARBOUND_INSTALL_PATH}"

# Remove old version files, if any. "|| true" ignores any failures, while "2>/dev/null" silences the error messages.
# It's normal for file-not-found errors to occur here if we're doing a fresh install, or upgrading from a 3.x build.
rm "${STEAM_INSTALL_DIR}/mods/Starbecue*.pak" 2>/dev/null || true
rm "${STEAM_INSTALL_DIR}/mods/starboundSpeciesAnimOverrides*.pak" 2>/dev/null || true
rm "${STEAM_INSTALL_DIR}/mods/SBQ_engine_assets*.pak" 2>/dev/null || true

# add new files
cp -rf linux/* "${STEAM_INSTALL_DIR}/linux"
cp -rf mods/* "${STEAM_INSTALL_DIR}/mods"
cp -rf assets/* "${STEAM_INSTALL_DIR}/assets"

chmod +x "${STEAM_INSTALL_DIR}/linux/starbound"

echo "Installation completed!"
