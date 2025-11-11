#!/bin/sh -e

rm -rf Starbecue
git clone https://github.com/WasabiRaptor/Starbecue
rm -rf Fuck-Your-Race-Effects
git clone https://github.com/WasabiRaptor/Fuck-Your-Race-Effects
rm -rf sb_pokemon
git clone https://github.com/WasabiRaptor/sb_pokemon
rm -rf SB_MetroidDoors
git clone https://github.com/WasabiRaptor/SB_MetroidDoors
rm -rf SBQ-compatibility
git clone https://github.com/WasabiRaptor/SBQ-compatibility
rm -rf SBQ-fockoff
git clone https://github.com/FockoffPollo/SBQ-fockoff


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
./dist/asset_packer -c scripts/packing.config SBQ-compatibility client_distribution/mods/SBQ-compatibility.pak
./dist/asset_packer -c scripts/packing.config SBQ-fockoff client_distribution/mods/SBQ-fockoff.pak

mkdir client_distribution/linux
cp \
  dist/starbound \
  dist/btree_repacker \
  dist/asset_packer \
  dist/asset_unpacker \
  dist/dump_versioned_json \
  dist/make_versioned_json \
  lib/linux/libdiscord_game_sdk.so \
  lib/linux/libsteam_api.so \
  scripts/ci/linux/sbinit.config \
  scripts/ci/linux/run-client.sh \
  scripts/steam_appid.txt \
  client_distribution/linux/

mkdir server_distribution
mkdir server_distribution/assets

mkdir server_distribution/mods
touch server_distribution/mods/mods_go_here

./dist/asset_packer -c scripts/packing.config -s assets/opensb server_distribution/assets/opensb.pak
./dist/asset_packer -c scripts/packing.config -s Starbecue server_distribution/mods/starbecue.pak
./dist/asset_packer -c scripts/packing.config -s Fuck-Your-Race-Effects server_distribution/mods/ShutUpAboutRaceEffects.pak
./dist/asset_packer -c scripts/packing.config -s sb_pokemon server_distribution/mods/Raptors_Pokemon.pak
./dist/asset_packer -c scripts/packing.config -s SB_MetroidDoors server_distribution/mods/Raptors_MetroidDoors.pak
./dist/asset_packer -c scripts/packing.config -s SBQ-compatibility server_distribution/mods/SBQ-compatibility.pak
./dist/asset_packer -c scripts/packing.config -s SBQ-fockoff server_distribution/mods/SBQ-fockoff.pak

cp Starbecue/README.md client_distribution/Starbecue_readme.md
cp Starbecue/README.md server_distribution/Starbecue_readme.md

cp Starbecue/features.md client_distribution/Starbecue_features.md
cp Starbecue/features.md server_distribution/Starbecue_features.md

cp Starbecue/FAQ.md client_distribution/Starbecue_FAQ.md
cp Starbecue/FAQ.md server_distribution/Starbecue_FAQ.md

cp README.md client_distribution/OpenSB_readme.md
cp README.md server_distribution/OpenSB_readme.md

cp scripts/ci/linux/install.sh client_distribution/install.sh
cp scripts/ci/linux/install.sh server_distribution/install.sh

mkdir server_distribution/linux

# makes the server function on older Linux versions (this is so stupid)
nm --dynamic --undefined-only --with-symbol-versions dist/starbound_server | grep GLIBC_2.29
./scripts/ci/linux/patchelf dist/starbound_server \
  --clear-symbol-version exp \
  --clear-symbol-version exp2 \
  --clear-symbol-version log \
  --clear-symbol-version log2 \
  --clear-symbol-version pow

cp \
  dist/starbound_server \
  dist/btree_repacker \
  scripts/ci/linux/run-server.sh \
  scripts/ci/linux/sbinit.config \
  scripts/steam_appid.txt \
  server_distribution/linux/

tar -cvf client.tar client_distribution
tar -cvf server.tar server_distribution
