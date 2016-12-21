#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

#echo "--- updating plist --- `date`"

APP_PATH="../../targets/${1}/${2}"
APP_PLIST_INFO_PATH="$APP_PATH/${2}-Info.plist"


#echo "The present working directory is `pwd`"


function updateLibraryPlist()
{
	
	var_hockeyapp_id=$(sed "s/\"/'/g" <<< $4)
	/usr/libexec/PlistBuddy -c "set :RTIHockeyAppId $var_hockeyapp_id" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:RTIHockeyAppId: $APP_PLIST_INFO_PATH

	var_appName=$(sed "s/\"/'/g" <<< $2)
	/usr/libexec/PlistBuddy -c "set:CFBundleDisplayName $var_appName" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:CFBundleDisplayName: $APP_PLIST_INFO_PATH
	
	if [ $3 != "com.retrieve.retrieveProd0001" ]; then
		var_bundle_identifier=$(sed "s/\"/'/g" <<< $3)
		/usr/libexec/PlistBuddy -c "set :CFBundleIdentifier $var_bundle_identifier" $APP_PLIST_INFO_PATH
	fi
	#/usr/libexec/PlistBuddy -c Print:CFBundleIdentifier: $APP_PLIST_INFO_PATH
	
	prod_number=$(sed -ne "/^RTI_PRODUCT_VERSION/s/[^0.-9.]//gp" ../../Config/BuildNumber.xcconfig)
	/usr/libexec/PlistBuddy -c "set:CFBundleShortVersionString $prod_number" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:CFBundleShortVersionString: $APP_PLIST_INFO_PATH
	
	build_number=$(sed -ne "/^RTI_PRODUCT_BUILD/s/[^0-9]//gp" ../../Config/BuildNumber.xcconfig)
	/usr/libexec/PlistBuddy -c "set:CFBundleVersion $build_number" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:CFBundleVersion: $APP_PLIST_INFO_PATH
	
	/usr/libexec/PlistBuddy -c "set:RTISiteId 1" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:RTISiteId: $APP_PLIST_INFO_PATH
	
	var_tagline=$(sed "s/\"/'/g" <<< $5)
	/usr/libexec/PlistBuddy -c "set:RTITagline $var_tagline" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:RTITagline: $APP_PLIST_INFO_PATH

}

function updateStandalonePlist()
{
	
	var_control_code=$(sed "s/\"/'/g" <<< $4)
	/usr/libexec/PlistBuddy -c "set :RTIBookControlCode $var_control_code" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:RTIBookControlCode: $APP_PLIST_INFO_PATH

	var_book_id=$1
	/usr/libexec/PlistBuddy -c "set :RTIBookId $var_book_id" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:RTIBookId: $APP_PLIST_INFO_PATH

	var_hockeyapp_id=$(sed "s/\"/'/g" <<< $5)
	/usr/libexec/PlistBuddy -c "set :RTIHockeyAppId $var_hockeyapp_id" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:RTIHockeyAppId: $APP_PLIST_INFO_PATH
	
	var_appName=$(sed "s/\"/'/g" <<< $2)
	/usr/libexec/PlistBuddy -c "set:CFBundleDisplayName $var_appName" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:CFBundleDisplayName: $APP_PLIST_INFO_PATH
	
	var_bundle_identifier=$(sed "s/\"/'/g" <<< $3)
	/usr/libexec/PlistBuddy -c "set :CFBundleIdentifier $var_bundle_identifier" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:CFBundleIdentifier: $APP_PLIST_INFO_PATH
	
	prod_number=$(sed -ne "/^RTI_PRODUCT_VERSION/s/[^0.-9.]//gp" ../../Config/BuildNumber.xcconfig)
	/usr/libexec/PlistBuddy -c "set:CFBundleShortVersionString $prod_number" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:CFBundleShortVersionString: $APP_PLIST_INFO_PATH
	
	build_number=$(sed -ne "/^RTI_PRODUCT_BUILD/s/[^0-9]//gp" ../../Config/BuildNumber.xcconfig)
	/usr/libexec/PlistBuddy -c "set:CFBundleVersion $build_number" $APP_PLIST_INFO_PATH
	#/usr/libexec/PlistBuddy -c Print:CFBundleVersion: $APP_PLIST_INFO_PATH

	var_tagline=$(sed "s/\"/'/g" <<< $6)
	/usr/libexec/PlistBuddy -c "set:RTITagline $var_tagline" $APP_PLIST_INFO_PATH
}


if [ ${1} == "library" ]; then
	updateLibraryPlist "${2}" "${3}" "${4}" "${5}" "${6}"
	#echo "${2}" 
	#echo "${3}" 
	#echo "${4}"
	#echo "${5}"
	#echo "${6}"
elif [ ${1} == "standalone" ]; then
	#echo "${2}" 
	#echo "${3}" 
	#echo "${4}"
	#echo "${5}"
	#echo "${6}"
	#echo "${7}"
	updateStandalonePlist "${2}" "${3}" "${4}" "${5}" "${6}" "${7}"
else
	echo "Please check you parameters."
fi


