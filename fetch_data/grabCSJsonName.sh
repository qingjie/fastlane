#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

APP_CS_TARGET="../../targets/${1}"
APP_SH_TARGET="../../../sh/temp-all.txt"

echo " **************** start to grab json names of CS at `date`  **************** "

content=$(wget ${2}  -q -O -)


if [ ${3} == "all" ]; then

	mkdir -p $APP_CS_TARGET
	echo $content>$APP_CS_TARGET/${1}.json
	
	if [ -e "$APP_CS_TARGET/${1}.json" ]; then
		
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
			echo $j
			echo $j>>$APP_SH_TARGET
			
		done
		rm -rf $APP_CS_TARGET/${1}.json
	else
		echo "file json is not exists."
	fi
fi


echo "  **************** end to grab json names of CS at `date`  ****************  "

