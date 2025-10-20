$DID_FIND_STARBOUND = 0
$STARBOUND_INSTALL_PATH = ""

if ($args.Count -ne 0) {
    $STARBOUND_INSTALL_PATH = $args -join " " -replace '"',''
} else {
    # We don't know what drive the user has Steam installed to, so we'll need to figure it out ourselves.
    $DRIVE_LETTERS = 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
    $FOUND_STEAM = 0
    $STEAM_DRIVE_LETTER = ""

    foreach ($DRIVE_LETTER in $DRIVE_LETTERS) {
        if (Test-Path "${DRIVE_LETTER}:\\Program Files (x86)\\Steam\\steam.exe") {
            $FOUND_STEAM = 1
            $STEAM_DRIVE_LETTER = $DRIVE_LETTER
            break
        }
    }

    if ($FOUND_STEAM -eq 0) {
        Write-Host "Couldn't find Steam!"
        Write-Host ""
        Write-Host "You may manually specify a Starbound installation path instead by re-running this script like so:"
        Write-Host "`tinstall.bat C:\full\path\to\starbound\root\dir"
        exit 1
    }

    Write-Host "Automatically found Steam: ${DRIVE_LETTER}:\\Program Files (x86)\\Steam\\"

    # Now we can extract the library paths and Starbound app id.
    $STEAM_LIBPATHS_CONFIG = "${STEAM_DRIVE_LETTER}:\\Program Files (x86)\\Steam\\config\\libraryfolders.vdf"
    $STEAM_LIBPATHS = Get-Content $STEAM_LIBPATHS_CONFIG
    $STEAM_LIBPATHS = $STEAM_LIBPATHS -replace '\t+',"`t"
    $STEAM_LIBPATHS = $STEAM_LIBPATHS | Select-String -Pattern '^((\t*"path"\t"[^"]+")|(\t"211820"\t"[0-9]+"))'
    $STEAM_LIBPATHS = $STEAM_LIBPATHS -replace '\t"path"\t','' -replace '\t"211820"\t".*',':211820' -replace '"','' -replace '\r\n',"\n"

    $LAST_PATH=""
    $CUR_PATH=""

    # Iterate through STEAM_LIBPATHS and look for a path/appid pair.
    foreach ($CUR_PATH in $($STEAM_LIBPATHS -split "`n")) {
        if ($CUR_PATH -eq ":211820") {
            $DID_FIND_STARBOUND = 1
            $STARBOUND_INSTALL_PATH = $LAST_PATH + "\\steamapps\\common\\Starbound"
            break
        }

        $LAST_PATH = $CUR_PATH
    }

    # If we didn't find the path, bail out and tell the user how they can workaround this if needed.
    if ($DID_FIND_STARBOUND -eq 0) {
        Write-Host "Couldn't find your Starbound installation!"
        Write-Host ""
        Write-Host "Please ensure that your SteamLibrary is setup correctly!"
        Write-Host "If this is a new installation of Starbound, you may need to restart Steam first for this script to be able to find it."
        Write-Host "Alternatively, you may manually specify a Starbound installation path by re-running this script like so:"
        Write-Host "`tinstall.bat C:\full\path\to\starbound\root\dir"
        exit 1
    }
}

if ($DID_FIND_STARBOUND -eq 1) {
    Write-Host "Automatically found your Starbound installation: $STARBOUND_INSTALL_PATH"
} else {
    Write-Host "Using manually-specified Starbound installation: $STARBOUND_INSTALL_PATH"
}

# Make sure whatever path we're using is a valid Starbound installation.
if (-not (Test-Path "$STARBOUND_INSTALL_PATH\\win64\\starbound.exe")) {
    Write-Host "The Starbound installation path does not appear to be valid (missing game executable)!"
    Write-Host ""

    if ($DID_FIND_STARBOUND -eq 1) {
        Write-Host "You can manually specify your Starbound installation path instead by re-running this script like so:"
        Write-Host "`tinstall.bat C:\full\path\to\starbound\root\dir"
    } else {
        Write-Host "Please double check that the path you typed points towards the root folder of your Starbound installation."
    }

    exit 1
}

# Everything checks out; let's get installing!
$STEAM_STARBOUND_DIR = $STARBOUND_INSTALL_PATH

# Remove old version files
Remove-Item "$STEAM_STARBOUND_DIR\\mods\\Starbecue*.pak" -ErrorAction SilentlyContinue
Remove-Item "$STEAM_STARBOUND_DIR\\mods\\starboundSpeciesAnimOverrides*.pak" -ErrorAction SilentlyContinue
Remove-Item "$STEAM_STARBOUND_DIR\\mods\\SBQ_engine_assets*.pak" -ErrorAction SilentlyContinue

# Copy new files
Write-Host $STEAM_STARBOUND_DIR
Copy-Item -Path "mods\*" -Destination "$STEAM_STARBOUND_DIR\mods\" -Recurse
Copy-Item -Path "assets\*" -Destination "$STEAM_STARBOUND_DIR\assets\" -Recurse
Copy-Item -Path "win\*" -Destination "$STEAM_STARBOUND_DIR\win64\" -Recurse

Write-Host "Installation completed!"
Pause
