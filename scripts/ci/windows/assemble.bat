@echo off
set client=client_distribution
if exist %client% rmdir %client% /S /Q

mkdir %client%
mkdir %client%\storage
mkdir %client%\mods
mkdir %client%\logs
mkdir %client%\assets
mkdir %client%\win
echo 211820 > %client%\win\steam_appid.txt

set server=server_distribution
if exist %server% rmdir %server% /S /Q
xcopy %client% %server% /E /I

if exist Starbecue rmdir Starbecue /S /Q
if exist Fuck-Your-Race-Effects rmdir Fuck-Your-Race-Effects /S /Q

git clone https://github.com/WasabiRaptor/Starbecue -b 4.0
git clone https://github.com/WasabiRaptor/Fuck-Your-Race-Effects

xcopy Starbecue\README.md %client%\Starbecue_readme.md /Y
xcopy Starbecue\README.md %server%\Starbecue_readme.md /Y

xcopy Starbecue\features.md %client%\Starbecue_features.md /Y
xcopy Starbecue\features.md %server%\Starbecue_features.md /Y

xcopy Starbecue\FAQ.md %client%\Starbecue_FAQ.md /Y
xcopy Starbecue\FAQ.md %server%\Starbecue_FAQ.md /Y

.\dist\asset_packer.exe -c scripts\packing.config assets\opensb %client%\assets\opensb.pak
.\dist\asset_packer.exe -c scripts\packing.config Starbecue %client%\mods\starbecue.pak
.\dist\asset_packer.exe -c scripts\packing.config Fuck-Your-Race-Effects %client%\mods\ShutUpAboutRaceEffects.pak

for /f "delims=" %%f in (scripts\ci\windows\files_client.txt) do (
    xcopy "%%f" "%client%\win\" /Y
)

.\dist\asset_packer.exe -c scripts\packing.config -s assets\opensb %server%\assets\opensb.pak
.\dist\asset_packer.exe -c scripts\packing.config -s Starbecue %server%\mods\starbecue.pak
.\dist\asset_packer.exe -c scripts\packing.config -s Fuck-Your-Race-Effects %server%\mods\ShutUpAboutRaceEffects.pak

for /f "delims=" %%f in (scripts\ci\windows\files_server.txt) do (
    xcopy "%%f" "%server%\win\" /Y
)

set win=windows
if exist %win% rmdir %win% /S /Q
xcopy %client% %win% /E /I /Y
xcopy %server% %win% /E /I /Y
