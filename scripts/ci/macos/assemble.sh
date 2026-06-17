#!/bin/sh -e
rm -rf Starbecue
git clone https://github.com/WasabiRaptor/Starbecue -b 4.1
rm -rf Lexi-Starbound-Lib
git clone https://github.com/WasabiRaptor/Lexi-Starbound-Lib
rm -rf Fuck-Your-Race-Effects
git clone https://github.com/WasabiRaptor/Fuck-Your-Race-Effects
rm -rf Lexis-Pokemon-Races
git clone https://github.com/WasabiRaptor/Lexis-Pokemon-Races
rm -rf Lexis-Races
git clone https://github.com/WasabiRaptor/Lexis-Races
rm -rf SB_MetroidDoors
git clone https://github.com/WasabiRaptor/SB_MetroidDoors
rm -rf SBQ-compatibility
git clone https://github.com/WasabiRaptor/SBQ-compatibility
rm -rf SBQ-LokiVulpix
git clone https://github.com/WasabiRaptor/SBQ-LokiVulpix
rm -rf SBQ-fockoff
git clone https://github.com/FockoffPollo/SBQ-fockoff

mkdir client_distribution
mkdir client_distribution/assets
mkdir client_distribution/assets/user

./dist/asset_packer -c scripts/packing.config assets/opensb client_distribution/assets/opensb.pak

mkdir client_distribution/mods
touch client_distribution/mods/mods_go_here

./dist/asset_packer -c scripts/packing.config Starbecue client_distribution/mods/starbecue.pak
./dist/asset_packer -c scripts/packing.config Lexi-Starbound-Lib client_distribution/mods/Lexi-lib.pak
./dist/asset_packer -c scripts/packing.config Fuck-Your-Race-Effects client_distribution/mods/ShutUpAboutRaceEffects.pak
./dist/asset_packer -c scripts/packing.config Lexis-Pokemon-Races client_distribution/mods/Lexi-Pokemon.pak
./dist/asset_packer -c scripts/packing.config Lexis-Races client_distribution/mods/Lexi-Races.pak
./dist/asset_packer -c scripts/packing.config SB_MetroidDoors client_distribution/mods/Lexi-MetroidDoors.pak
./dist/asset_packer -c scripts/packing.config SBQ-compatibility client_distribution/mods/SBQ-compatibility.pak
./dist/asset_packer -c scripts/packing.config SBQ-LokiVulpix client_distribution/mods/SBQ-LokiVulpix.pak
./dist/asset_packer -c scripts/packing.config SBQ-fockoff client_distribution/mods/SBQ-fockoff.pak

cp Starbecue/README.md client_distribution/Starbecue_readme.md.txt

cp Starbecue/features.md client_distribution/Starbecue_features.md.txt

cp Starbecue/FAQ.md client_distribution/Starbecue_FAQ.md.txt

cp README.md client_distribution/OpenSB_readme.md.txt

cp scripts/ci/macos/install.sh client_distribution/install.sh

mkdir client_distribution/osx
cp -LR scripts/ci/macos/Starbound.app client_distribution/osx/
mkdir client_distribution/osx/Starbound.app/Contents/MacOS
cp dist/starbound client_distribution/osx/Starbound.app/Contents/MacOS/
cp dist/*.dylib client_distribution/osx/Starbound.app/Contents/MacOS/
cp \
  dist/starbound_server \
  dist/btree_repacker \
  dist/asset_packer \
  dist/asset_unpacker \
  dist/dump_versioned_json \
  dist/make_versioned_json \
  scripts/ci/macos/sbinit.config \
  scripts/ci/macos/run-server.sh \
  scripts/steam_appid.txt \
  client_distribution/osx/

tarlz -c9vf client.tar.lz client_distribution
