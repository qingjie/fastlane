#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

echo "resume - building  - `date`"
APP_SOURCE="./../RetrieveApp"
BACKUP_APP_PATH="$APP_SOURCE/targets/${1}/${3}"
DEFAULT_APP_ICON_PATH="$APP_SOURCE/RetrieveApp/Icons.xcassets/standalone.appiconset/"
DEFAULT_LIB_ICON_PATH="$APP_SOURCE/RetrieveApp/Icons.xcassets/library.appiconset/"
DEFAULT_SPLASH_LOGO_PATH="$APP_SOURCE/RetrieveApp/Images.xcassets/Splash/Splash Logo.imageset/"
DEFAULT_SPLASH_BACKGROUND_PATH="$APP_SOURCE/RetrieveApp/Images.xcassets/Splash/Splash Background.imageset/"
PROJECT_NAME="RetrieveApp"
XCSCHEME_PATH="$APP_SOURCE/RetrieveApp.xcodeproj/xcshareddata/xcschemes"
PBXPROJ_PATH="$APP_SOURCE/RetrieveApp.xcodeproj/project.pbxproj"
DEFAULT_BUNDLE_ID="com.retrieve.retrieveProd${3}"
NEW_BUNDLE_ID="com.retrieve.retrieveProd${2}"

echo "------------ start to resume -----------"

cat "$BACKUP_APP_PATH/${3}-Info.plist">"$APP_SOURCE/$PROJECT_NAME/Configs/${1}/default-Info.plist"

#echo "The present working directory is `pwd`"


#repleace new bundle_id with default bundle_id
sed -i '' "s/$NEW_BUNDLE_ID/$DEFAULT_BUNDLE_ID/g" "$PBXPROJ_PATH"



if [ ${1} == "library" ]
then
	#rename scheme
	mv "$XCSCHEME_PATH/${2}-Library.xcscheme" "$XCSCHEME_PATH/${3}-Library.xcscheme"
	#replace target name with default
	sed -i '' "s/${2}-Library/${3}-Library/g" "$PBXPROJ_PATH"
	sed -i '' "s/${2}-Library/${3}-Library/g" "$XCSCHEME_PATH/${3}-Library.xcscheme"
	cp "$BACKUP_APP_PATH/icon/"* "$DEFAULT_LIB_ICON_PATH" &> /dev/null
else
	#rename scheme
	mv "$XCSCHEME_PATH/${2}.xcscheme" "$XCSCHEME_PATH/${3}.xcscheme"
	#replace target name with default
	sed -i '' "s/${2}/${3}/g" "$PBXPROJ_PATH"
	sed -i '' "s/${2}/${3}/g" "$XCSCHEME_PATH/${3}.xcscheme"
	cp "$BACKUP_APP_PATH/icon/"* "$DEFAULT_APP_ICON_PATH" &> /dev/null
fi

cp "$BACKUP_APP_PATH/logo/"* "$DEFAULT_SPLASH_LOGO_PATH" &> /dev/null
cp "$BACKUP_APP_PATH/splash/"* "$DEFAULT_SPLASH_BACKGROUND_PATH" &> /dev/null

echo "------------ end to resume -----------"

#resume.sh standalone 2493 2492
#resume.sh library 0426 0000



