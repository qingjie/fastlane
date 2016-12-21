#!/bin/sh

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

CLR_BLUE="\033[0;36m"
CLR_RED="\033[0;41m"
CLR_NORMAL="\033[0m"

pushd `dirname $0` > /dev/null

function syntax
{
    echo "usage: buildAndArchive-XXXX.sh scheme [nobumpbuild]"
    echo "  scheme      - the app you want to build, e.g. 2492"
    echo "  nobumpbuild - don't bump the build number"
    exit 1
}


if [ $# -ne 2 ] && [ $# -ne 3 ]; then
	syntax
fi

if [ "$1" == "" ]; then
    echo "${CLR_RED}Please specify the app number${CLR_NORMAL}"
    syntax
fi

nobumpbuild=${3:-}
if [ "$nobumpbuild" = "nobumpbuild" ]; then
    nobumpbuild=true
else
	if [ "$nobumpbuild" = "" ]; then
   		nobumpbuild=false
   	else
	    echo "${CLR_RED}Invalid second argument${CLR_NORMAL}"
	    syntax
	fi
fi


BUILD_CONFIGURATION=$2
BUILD_DESIGNATION=${BUILD_CONFIGURATION/ /}

ARCHIVE_PATH="Builds/${1}"
ARCHIVE_NAME="$ARCHIVE_PATH/$1-$BUILD_DESIGNATION.xcarchive"
EXPORT_PATH="Builds/${1}"
BUILD_LOG_PATH="Builds/${1}/${1}-build.log"
EXPORT_LOG_PATH="Builds/${1}/${1}-export.log"

rm -Rf "${ARCHIVE_PATH}" &> /dev/null
rm -Rf "${EXPORT_PATH}" &> /dev/null
mkdir -p "Builds/${1}/" &> /dev/null


echo "------------------------------------------------"

echo "${1} - Settings             - `date`"
echo "  ARCHIVE_PATH=$ARCHIVE_PATH"
echo "  EXPORT_PATH=$EXPORT_PATH"
echo "  BUILD_CONFIGURATION=${CLR_BLUE}$BUILD_CONFIGURATION${CLR_NORMAL}"

if [ "$nobumpbuild" != true ]; then
    echo "${1} - Bump Build Number    - `date`"
    ./bumpBuildNum.sh
fi

echo "${1} - Building + Archiving - `date`"

xcodebuild -project "../RetrieveApp/RetrieveApp.xcodeproj" -scheme "${1}" -configuration "${BUILD_CONFIGURATION}" clean archive -archivePath "${ARCHIVE_NAME}" >> ${BUILD_LOG_PATH}

echo "${1} - Exporting: Ad-Hoc    - `date`"
xcodebuild -exportArchive -archivePath "${ARCHIVE_NAME}" -exportPath "${EXPORT_PATH}" -exportOptionsPlist ./exportOptions-AdHoc.plist > "${EXPORT_LOG_PATH}"
mv "${EXPORT_PATH}/$1.ipa" "${EXPORT_PATH}/$1-$BUILD_DESIGNATION-AdHoc.ipa"
echo "  Exported:${CLR_BLUE} ${EXPORT_PATH}/$1-$BUILD_DESIGNATION-AdHoc.ipa ${CLR_NORMAL}"

echo "${1} - Exporting .dSYMS     - `date`"
zip -r "${EXPORT_PATH}/dSYM.zip" "${EXPORT_PATH}"/*.xcarchive/dSYMs/*

if [[ "$BUILD_CONFIGURATION" =~ "Production" ]]; then
	echo "${1} - Exporting: App Store - `date`"
    xcodebuild -exportArchive -archivePath "${ARCHIVE_NAME}" -exportPath "${EXPORT_PATH}" -exportOptionsPlist ./exportOptions-AppStore.plist >> "${EXPORT_LOG_PATH}"
    mv "${EXPORT_PATH}/$1.ipa" "${EXPORT_PATH}/$1-$BUILD_DESIGNATION-AppStore.ipa"
	echo "  Exported:${CLR_BLUE} ${EXPORT_PATH}/$1-$BUILD_DESIGNATION-AppStore.ipa ${CLR_NORMAL}"
fi


echo "${1} - COMPLETE             - `date`"
echo "------------------------------------------------"
