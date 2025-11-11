@echo off
set client=client_distribution
if exist %client% rmdir %client% /S /Q

mkdir %client%
mkdir %client%\storage
mkdir %client%\mods
mkdir %client%\logs
mkdir %client%\assets
mkdir %client%\win64
echo 211820 > %client%\win64\steam_appid.txt

set server=server_distribution
if exist %server% rmdir %server% /S /Q
xcopy %client% %server% /E /I

if exist Starbecue rmdir Starbecue /S /Q
if exist Fuck-Your-Race-Effects rmdir Fuck-Your-Race-Effects /S /Q
if exist sb_pokemon rmdir sb_pokemon /S /Q
if exist SB_MetroidDoors rmdir SB_MetroidDoors /S /Q
if exist SBQ-compatibility rmdir SBQ-compatibility /S /Q
if exist SBQ-fockoff rmdir SBQ-fockoff /S /Q

git clone https://github.com/WasabiRaptor/Starbecue
git clone https://github.com/WasabiRaptor/Fuck-Your-Race-Effects
git clone https://github.com/WasabiRaptor/sb_pokemon
git clone https://github.com/WasabiRaptor/SB_MetroidDoors
git clone https://github.com/WasabiRaptor/SBQ-compatibility
git clone https://github.com/WasabiRaptor/SBQ-fockoff

copy Starbecue\README.md %client%\Starbecue_readme.md /Y
copy Starbecue\README.md %server%\Starbecue_readme.md /Y

copy Starbecue\features.md %client%\Starbecue_features.md /Y
copy Starbecue\features.md %server%\Starbecue_features.md /Y

copy Starbecue\FAQ.md %client%\Starbecue_FAQ.md /Y
copy Starbecue\FAQ.md %server%\Starbecue_FAQ.md /Y

copy README.md %client%\OpenSB_readme.md /Y
copy README.md %server%\OpenSB_readme.md /Y

copy scripts\ci\windows\install.bat %client%\install.bat /Y
copy scripts\ci\windows\install.bat %server%\install.bat /Y
copy scripts\ci\windows\install.ps1 %client%\install.ps1 /Y
copy scripts\ci\windows\install.ps1 %server%\install.ps1 /Y

.\dist\asset_packer.exe -c scripts\packing.config assets\opensb %client%\assets\opensb.pak
.\dist\asset_packer.exe -c scripts\packing.config Starbecue %client%\mods\starbecue.pak
.\dist\asset_packer.exe -c scripts\packing.config Fuck-Your-Race-Effects %client%\mods\ShutUpAboutRaceEffects.pak
.\dist\asset_packer.exe -c scripts\packing.config sb_pokemon %client%\mods\Raptors_Pokemon.pak
.\dist\asset_packer.exe -c scripts\packing.config SB_MetroidDoors %client%\mods\Raptors_MetroidDoors.pak
.\dist\asset_packer.exe -c scripts\packing.config SBQ-compatibility %client%\mods\SBQ-compatibility.pak
.\dist\asset_packer.exe -c scripts\packing.config SBQ-fockoff %client%\mods\SBQ-fockoff.pak

for /f "delims=" %%f in (scripts\ci\windows\files_client.txt) do (
    xcopy "%%f" "%client%\win64\" /Y
)

.\dist\asset_packer.exe -c scripts\packing.config -s assets\opensb %server%\assets\opensb.pak
.\dist\asset_packer.exe -c scripts\packing.config -s Starbecue %server%\mods\starbecue.pak
.\dist\asset_packer.exe -c scripts\packing.config -s Fuck-Your-Race-Effects %server%\mods\ShutUpAboutRaceEffects.pak
.\dist\asset_packer.exe -c scripts\packing.config -s sb_pokemon %server%\mods\Raptors_Pokemon.pak
.\dist\asset_packer.exe -c scripts\packing.config -s SB_MetroidDoors %server%\mods\Raptors_MetroidDoors.pak
.\dist\asset_packer.exe -c scripts\packing.config -s SBQ-compatibility %server%\mods\SBQ-compatibility.pak
.\dist\asset_packer.exe -c scripts\packing.config -s SBQ-fockoff %server%\mods\SBQ-fockoff.pak

for /f "delims=" %%f in (scripts\ci\windows\files_server.txt) do (
    xcopy "%%f" "%server%\win64\" /Y
)

set win=windows
if exist %win% rmdir %win% /S /Q
xcopy %client% %win% /E /I /Y
xcopy %server% %win% /E /I /Y
