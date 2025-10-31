#!/bin/sh -e
rm -rf Starbecue
git clone https://github.com/WasabiRaptor/Starbecue
rm -rf Fuck-Your-Race-Effects
git clone https://github.com/WasabiRaptor/Fuck-Your-Race-Effects
rm -rf sb_pokemon
git clone https://github.com/WasabiRaptor/sb_pokemon
rm -rf SB_MetroidDoors
git clone https://github.com/WasabiRaptor/SB_MetroidDoors

mkdir client_distribution
mkdir client_distribution/assets
mkdir client_distribution/assets/user

./dist/asset_packer -c scripts/packing.config assets/opensb client_distribution/assets/opensb.pak

mkdir client_distribution/mods
touch client_distribution/mods/mods_go_here

./dist/asset_packer -c scripts/packing.config Starbecue client_distribution/mods/starbecue.pak
./dist/asset_packer -c scripts/packing.config Fuck-Your-Race-Effects client_distribution/mods/ShutUpAboutRaceEffects.pak
./dist/asset_packer -c scripts/packing.config sb_pokemon client_distribution/mods/Raptors_Pokemon.pak
./dist/asset_packer -c scripts/packing.config SB_MetroidDoors client_distribution/mods/Raptors_MetroidDoors.pak

cp Starbecue/README.md client_distribution/Starbecue_readme.md

cp Starbecue/features.md client_distribution/Starbecue_features.md

cp Starbecue/FAQ.md client_distribution/Starbecue_FAQ.md

cp README.md client_distribution/OpenSB_readme.md

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

tar -cvf client.tar client_distribution
