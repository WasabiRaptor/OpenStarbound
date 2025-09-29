#!/bin/sh -e
rm Starbecue -r -f
git clone https://github.com/WasabiRaptor/Starbecue -b 4.0
rm Fuck-Your-Race-Effects -r -f
git clone https://github.com/WasabiRaptor/Fuck-Your-Race-Effects
rm sb_pokemon -r -f
git clone https://github.com/WasabiRaptor/sb_pokemon
rm SB_MetroidDoors -r -f
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
