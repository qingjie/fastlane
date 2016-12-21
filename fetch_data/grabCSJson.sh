#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

APP_CS_TARGET="../../targets/${1}"
APP_SH_TARGET="../../../sh/temp-all.txt"

echo " **************** start to grab json of CS at `date`  **************** "

content=$(wget ${2}  -q -O -)

if [ ${3} == "all" ]; then
	echo $content > $APP_CS_TARGET/${1}.json
	
	if [ -e "$APP_CS_TARGET/${1}.json" ]; then
		echo "${1}.json exists and :all is not empty."
		
		echo "$APP_CS_TARGET/${1}.json"
		var_length=$( cat $APP_CS_TARGET/${1}.json | jq '. | length')
		for ((i=0;i<=$var_length-1;i++));
		do
			
			if [ ${1} == "library" ]; then
				var_lib_Id=$( cat $APP_CS_TARGET/${1}.json | jq ".[$i] | .libId" )
				var_json_name=$(sed 's/\"//g' <<< $var_lib_Id) 
			else
				var_app_Id=$( cat $APP_CS_TARGET/${1}.json | jq ".[$i] | .appId" )
				var_json_name=$(sed 's/\"//g' <<< $var_app_Id) 
			fi
			

			var_first=$( cat $APP_CS_TARGET/${1}.json | jq ".[$i]" )
			
			printf -v j "%04d" $var_json_name
			#echo $j
			
			echo $var_first > $APP_CS_TARGET/$j.json
			
			echo $j>>$APP_SH_TARGET
			

			if [ -e "$APP_CS_TARGET/$j.json" ]; then
		  		echo "$j.json exists and :$j.json is not empty."
		  		#./parseAllJson.sh ${1} ${3}
			else
		  		echo "$j.json is not exists."
			fi
		done
		rm -rf $APP_CS_TARGET/${1}.json
	else
		echo "file json is not exists."
	fi

else
	echo $content > $APP_CS_TARGET/${3}.json
	if [ -e "$APP_CS_TARGET/${3}.json" ]; then
		echo "${3}.json exists and it is not empty."
		if [ ${1} == "library" ]; then
			var_lib_Id=$( cat $APP_CS_TARGET/${3}.json | jq ".libId" )
			if [ ${3} == "0000" ]; then
				mv $APP_CS_TARGET/${3}.json $APP_CS_TARGET/0001.json 
			fi
			var_json_name=$(sed 's/\"//g' <<< $var_lib_Id) 
			printf -v j "%04d" $var_json_name
			mkdir -p $APP_CS_TARGET/$j &> /dev/null
			
			if [ -e "$APP_CS_TARGET/$j.json" ]; then

		  		echo "$j.json of ${1} exists and :$j.json is not empty."
		  		#./parseAllJson.sh ${1} $j
			else
		  		echo "$j.json of ${1} is not exists."
			fi
		else
			var_app_Id=$( cat $APP_CS_TARGET/${3}.json | jq ".appId" )
			var_json_name=$(sed 's/\"//g' <<< $var_app_Id) 
			mkdir -p $APP_CS_TARGET/$var_json_name &> /dev/null
			#./parseAllJson.sh ${1} ${3}
		fi
	else
		echo "${3}.json is not exists."
	fi

fi


if [ ${3} == "0000" ]; then
	./parseAllJson.sh ${1} "0001"
else
	./parseAllJson.sh ${1} ${3}
fi


echo "  **************** end to grab json of CS at `date`  ****************  "

