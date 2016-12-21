#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

echo "${2} - building  - `date`"
APP_SOURCE="./../RetrieveApp"
NEW_APP_PATH="$APP_SOURCE/targets/${1}/${2}"
DEFAULT_APP_ICON_PATH="$APP_SOURCE/RetrieveApp/Icons.xcassets/standalone.appiconset/"
DEFAULT_LIB_ICON_PATH="$APP_SOURCE/RetrieveApp/Icons.xcassets/library.appiconset/"
DEFAULT_SPLASH_LOGO_PATH="$APP_SOURCE/RetrieveApp/Images.xcassets/Splash/Splash Logo.imageset/"
DEFAULT_SPLASH_BACKGROUND_PATH="$APP_SOURCE/RetrieveApp/Images.xcassets/Splash/Splash Background.imageset/"
PROJECT_NAME="RetrieveApp"
XCSCHEME_PATH="$APP_SOURCE/RetrieveApp.xcodeproj/xcshareddata/xcschemes"
PBXPROJ_PATH="$APP_SOURCE/RetrieveApp.xcodeproj/project.pbxproj"
DEFAULT_BUNDLE_ID="com.retrieve.retrieveProd${3}"
NEW_BUNDLE_ID="com.retrieve.retrieveProd${2}"

#copy new logo into project

#echo "The present working directory is `pwd`"
echo "------------ start to create -----------"

if [ ${1} == "library" ]
then
	#rename scheme
	mv "$XCSCHEME_PATH/${3}-Library.xcscheme" "$XCSCHEME_PATH/${2}-Library.xcscheme" 
   	#replace targetname
	sed -i '' "s/${3}-Library/${2}-Library/g" "$PBXPROJ_PATH"
	sed -i '' "s/${3}-Library/${2}-Library/g" "$XCSCHEME_PATH/${2}-Library.xcscheme"
	cp "$NEW_APP_PATH/icon/"* "$DEFAULT_LIB_ICON_PATH/" &> /dev/null
else
   	#rename scheme
	mv "$XCSCHEME_PATH/${3}.xcscheme" "$XCSCHEME_PATH/${2}.xcscheme" 
   	#replace targetname
	sed -i '' "s/${3}/${2}/g" "$PBXPROJ_PATH"
	sed -i '' "s/${3}/${2}/g" "$XCSCHEME_PATH/${2}.xcscheme"
	cp "$NEW_APP_PATH/icon/"* "$DEFAULT_APP_ICON_PATH/" &> /dev/null
fi

cp "$NEW_APP_PATH/logo/"* "$DEFAULT_SPLASH_LOGO_PATH/" &> /dev/null
cp "$NEW_APP_PATH/splash/"* "$DEFAULT_SPLASH_BACKGROUND_PATH/" &> /dev/null


cat "$NEW_APP_PATH/${2}-Info.plist" > "$APP_SOURCE/$PROJECT_NAME/Configs/${1}/default-Info.plist"



#repleace default bundle_id with new bundle id
sed -i '' "s/$DEFAULT_BUNDLE_ID/$NEW_BUNDLE_ID/g" "$PBXPROJ_PATH"




echo "----------- end to create ------------"

# create.sh standalone 2493 2492
# create.sh library 0426 0000