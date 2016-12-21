#!/bin/sh

pushd `dirname $0` > /dev/null
echo "\033[0;41mBuilding for production\033[0m"

BUILD_PATH="../RetrieveApp/fastlane/build"
ARCHIVE_PATH="$BUILD_PATH/${1}"
EXPORT_PATH="$BUILD_PATH/${1}"
NEW_APP_PATH="../RetrieveApp/targets/${3}/${1}"

rm -Rf "${ARCHIVE_PATH}" &> /dev/null
rm -Rf "${EXPORT_PATH}" &> /dev/null
mkdir -p "$BUILD_PATH/${1}/" &> /dev/null

cp -r "$NEW_APP_PATH/icon.png" "$EXPORT_PATH" &> /dev/null
cp -r "$NEW_APP_PATH/ratings.json" "$EXPORT_PATH" &> /dev/null
cp -r "$NEW_APP_PATH/metadata" "$EXPORT_PATH" &> /dev/null

./_buildAndArchiveCommon-fastlane.sh "$1" "Release Production" "$2" "$3"


