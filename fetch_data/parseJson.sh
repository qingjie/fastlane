#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

echo " ******** start to parse ${1} ${2} at `date` *************"
#wget http://example.com/directory/file{1..10}.txt

APP_TARGET="../../targets"
APP_PATH="$APP_TARGET/${1}/${2}"
METADATA="$APP_PATH/metadata"
ICON="$APP_PATH/icon"
LOGO="$APP_PATH/logo"
SPLASH="$APP_PATH/splash"
METADATA_EN="$METADATA/en-US"
COMMON_DATA="common"

rm -rf $APP_PATH &> /dev/null

mkdir -p $METADATA_EN &> /dev/null
mkdir -p $ICON &> /dev/null
mkdir -p $LOGO &> /dev/null
mkdir -p $SPLASH &> /dev/null

touch $METADATA/copyright.txt &> /dev/null
touch $METADATA/primary_first_sub_category.txt &> /dev/null
touch $METADATA/primary_second_sub_category.txt &> /dev/null
touch $METADATA/secondary_category.txt &> /dev/null
touch $METADATA/secondary_first_sub_category.txt &> /dev/null
touch $METADATA/secondary_second_sub_category.txt &> /dev/null

cat ${1}/default-Info.plist>$APP_PATH/${2}-Info.plist

var_title=$( cat $APP_TARGET/${1}/${2}.json | jq '.title' )
if [ "$var_title" == "\"\"" ]; then
	echo "var_title of ${2} is null, ${2} can not get data to generate IPA"
else
	sed 's/\"//g' <<< $var_title > $METADATA_EN/name.txt
fi

var_price=$( cat $APP_TARGET/${1}/${2}.json | jq '.price' )
if [ "$var_price" == "\"\"" ]; then
	echo "var_price of ${2} is null, ${2} can not get data to generate IPA"
else
	sed 's/\"//g' <<< $var_price > $METADATA_EN/price.txt
fi


var_subTitle=$( cat $APP_TARGET/${1}/${2}.json | jq '.subtitle' )
if [ "$var_subTitle" == "\"\"" ]; then
	echo "subTitle is null"
fi

var_hockeyappId=$( cat $APP_TARGET/${1}/${2}.json | jq '.hockeyAppId' )


var_description=$( cat $APP_TARGET/${1}/${2}.json | jq '.description' )
if [ "$var_description" == "\"\"" ]; then
	echo "var_description of ${2} is null, ${2} can not get data to generate IPA"
else
	sed 's/\"//g' <<< $var_description > $METADATA_EN/description.txt
fi


var_keywords=$( cat $APP_TARGET/${1}/${2}.json | jq '.keywords' )
if [ "$var_keywords" == "\"\"" ]; then
	echo "var_keywords of ${2} is null, ${2} can not get data to generate IPA"
else
	sed 's/\"//g' <<< $var_keywords > $METADATA_EN/keywords.txt
fi


cp $COMMON_DATA/copyright.txt $METADATA/copyright.txt
cp $COMMON_DATA/marketing_url.txt $METADATA_EN/marketing_url.txt
cp $COMMON_DATA/privacy_url.txt $METADATA_EN/privacy_url.txt
cp $COMMON_DATA/support_url.txt $METADATA_EN/support_url.txt
cp ${1}/release_notes.txt $METADATA_EN/release_notes.txt


var_primary_category=$( cat $APP_TARGET/${1}/${2}.json | jq '.primaryCategory' )
#sed 's/\"//g' <<< MZGenre.$var_primary_category > $METADATA/primary_category.txt
if [ "$var_primary_category" == "\"\"" ]; then
	echo "var_primary_category of ${2} is null, ${2} can not get data to generate IPA"
else
	sed 's/\"//g' <<< $var_primary_category > $METADATA/primary_category.txt
fi

var_lib_splashTagline=$( cat $APP_TARGET/${1}/${2}.json | jq '.tagline' )
if [ "$var_lib_splashTagline" == "\"\"" ]; then
	echo "var_lib_splashTagline of ${2}.json is null."
fi

var_controlCode=$( cat $APP_TARGET/${1}/${2}.json | jq '.controlCode' )
#echo $var_controlCode
if [ "$var_controlCode" == "\"\"" ]; then
	echo "controlCode of ${2}.json is null,"
fi


var_ratings_ratingCartoonOrFantasyViolence=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingCartoonOrFantasyViolence' )
var_ratings_ratingRealisticViolence=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingRealisticViolence' )
var_ratings_ratingProlongedGraphicOrSadisticRealisticViolence=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingProlongedGraphicOrSadisticRealisticViolence' )
var_ratings_ratingProfanityOrCrudeHumor=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingProfanityOrCrudeHumor' )
var_ratings_ratingMatureSuggestiveThemes=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingMatureSuggestiveThemes' )
var_ratings_ratingHorrorFearThemes=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingHorrorFearThemes' )
var_ratings_ratingMedicalTreatmentInformation=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingMedicalTreatmentInformation' )
var_ratings_ratingAlcoholTobaccoOrDrugUseOrReferences=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingAlcoholTobaccoOrDrugUseOrReferences' )
var_ratings_ratingSimulatedGambling=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingSimulatedGambling' )
var_ratings_ratingSexualContentOrNudity=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingSexualContentOrNudity' )
var_ratings_ratingGraphicSexualContentAndNudity=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingGraphicSexualContentAndNudity' )
var_ratings_ratingUnrestricteWebAccess=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingUnrestricteWebAccess' )
var_ratings_ratingGamblingAndContests=$( cat $APP_TARGET/${1}/${2}.json | jq '.rating.ratingGamblingAndContests' )
var_ratings="{'CARTOON_FANTASY_VIOLENCE': $(sed 's/\"//g' <<< $var_ratings_ratingCartoonOrFantasyViolence), 
'REALISTIC_VIOLENCE':  $(sed 's/\"//g' <<< $var_ratings_ratingRealisticViolence),
'PROLONGED_GRAPHIC_SADISTIC_REALISTIC_VIOLENCE':  $(sed 's/\"//g' <<< $var_ratings_ratingProlongedGraphicOrSadisticRealisticViolence),
'PROFANITY_CRUDE_HUMOR':  $(sed 's/\"//g' <<< $var_ratings_ratingProfanityOrCrudeHumor),
'MATURE_SUGGESTIVE':  $(sed 's/\"//g' <<< $var_ratings_ratingMatureSuggestiveThemes),
'HORROR':  $(sed 's/\"//g' <<< $var_ratings_ratingHorrorFearThemes),
'MEDICAL_TREATMENT_INFO':  $(sed 's/\"//g' <<< $var_ratings_ratingMedicalTreatmentInformation),
'ALCOHOL_TOBACCO_DRUGS':  $(sed 's/\"//g' <<< $var_ratings_ratingAlcoholTobaccoOrDrugUseOrReferences),
'GAMBLING':  $(sed 's/\"//g' <<< $var_ratings_ratingSimulatedGambling),
'SEXUAL_CONTENT_NUDITY':  $(sed 's/\"//g' <<< $var_ratings_ratingSexualContentOrNudity),
'GRAPHIC_SEXUAL_CONTENT_NUDITY':  $(sed 's/\"//g' <<< $var_ratings_ratingGraphicSexualContentAndNudity),
'UNRESTRICTED_WEB_ACCESS':  $(sed 's/\"//g' <<< $var_ratings_ratingUnrestricteWebAccess),
'GAMBLING_CONTESTS':  $(sed 's/\"//g' <<< $var_ratings_ratingGamblingAndContests)}"
sed "s/'/\"/g" <<< $var_ratings>$APP_PATH/ratings.json


var_icon_image=$( cat $APP_TARGET/${1}/${2}.json | jq '.icon.icon_1024' )

if [ "$var_icon_image" == "\"\"" ]; then
	echo "var_icon_image of is null, ${2} can not get data to generate IPA"
else
	cd $APP_PATH && { curl -O $(sed 's/\"//g' <<< $var_icon_image) ; cd -; }
fi



for var_square in 29 40 58 76 80 87 120 152 167 180 
do 
	icon_url=$( cat $APP_TARGET/${1}/${2}.json | jq ".icon.iconSquare.icon_$var_square" )
	icon_name=$(echo ${icon_url##*/} | cut -f 1 -d '.')
	var_square_image="${icon_url%/*}/$icon_name.png"
	if [ "$var_square_image" == "\"\"" ]; then
		echo "var_square_image of is null, ${2} can not get data to generate IPA"
	else
		cd $ICON && { curl -O $(sed 's/\"//g' <<< $var_square_image) ; cd -; }
	fi
	
	echo $ICON/${var_square_image##*/}
done

for var_num in 1 2 3
do
	var_temp_logo_image=$( cat $APP_TARGET/${1}/${2}.json | jq ".splash.splashLogo.image_$var_num" )
	#echo $var_temp_logo_image
	cd $LOGO && { curl -O $(sed 's/\"//g' <<< $var_temp_logo_image) ; cd -; }
	logo_url=$(sed 's/\"//g' <<< $var_temp_logo_image)
	if [ "$logo_url" == "\"\"" ]; then
		echo "logo_url of is null, ${2} can not get data to generate IPA"
	else
		cd LOGO && { curl -O $(sed 's/\"//g' <<< $logo_url) ; cd -; }
	fi
	mv $LOGO/${logo_url##*/} $LOGO/"Splash Logo @"$var_num"x.png"
done

for var_num in 1 2 3
do
	var_temp_splash_Image=$( cat $APP_TARGET/${1}/${2}.json | jq ".splash.splashBackground.image_$var_num" )
	splash_Image_url=$(sed 's/\"//g' <<< $var_temp_splash_Image)
	if [ "$splash_Image_url" == "\"\"" ]; then
		echo "splash_Image_url of is null, ${2} can not get data to generate IPA"
	else
		cd $SPLASH && { curl -O $(sed 's/\"//g' <<< $splash_Image_url) ; cd -; }
	fi
	#echo ${splash_Image_url##*/}
	mv $SPLASH/${splash_Image_url##*/} $SPLASH/"Splash Background @"$var_num"x.png"
done

if [ ${1} == "library" ]; then
	#echo "----library---"	
	#./updatePlist.sh "library" "0001" "KApp Library" "com.retrieve.retrieveProd0001" "4e8b59e898c148beaeaeb7f1f00b8d4e" "Connecting people with information"
	./updatePlist.sh "${1}" "${2}" "$var_title" "com.retrieve.retrieveProd${2}" "$var_hockeyappId" "$var_lib_splashTagline"
else
	#./updatePlist.sh "standalone" "2492" "Learn Autodesk 3ds Max 2012 101" "com.retrieve.retrieveProd2492" "RQUFM-SGKLS-TLIPP-USFKO-DJEDC" "4e8b59e898c148beaeaeb7f1f00b8d4e" "Connecting people with information"
	./updatePlist.sh "${1}" "${2}" "$var_title" "com.retrieve.retrieveProd${2}" "$var_controlCode" "$var_hockeyappId" "$var_lib_splashTagline"
	#echo "----standalone------"
fi


#echo $var_controlCode 
#the_controlCode=$(sed "s/\"/'/g" <<< $var_controlCode)
#echo "$the_controlCode"

rm -rf $APP_TARGET/${1}/${2}.json
rm -rf $APP_TARGET/${1}.json

echo " *************** end to parse ${1} ${2}  at `date` ***************"

