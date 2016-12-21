#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

APP_TARGET="../../targets/${1}"
APP_DST_TARGET="../../targets/dst"
CER="?email=developers%40retrieve.com&authKey=9EmyAiRAIPciTh87PbAh%2FUlLAfwXrpl0NSl8IiB5APY%3D&libId=1"
IP_URL="http://192.168.128.243"
LIBRARY_URL="$IP_URL/bookserver/api/library-definitions/apple/"
STANDALONE_URL="$IP_URL/bookserver/api/app-definitions/apple/"

mkdir -p $APP_TARGET &> /dev/null

if [ ${1} == "library" ]; then
	if [ ${2} == "all" ]; then
		var_cs_url="$LIBRARY_URL$CER"
		#var_cs_url="http://192.168.128.243/bookserver/api/library-definitions/apple/?email=developers%40retrieve.com&authKey=9EmyAiRAIPciTh87PbAh%2FUlLAfwXrpl0NSl8IiB5APY%3D&libId=1"
	else
		if [ ${2} == "0000" ]; then
			num=1
		else
			num=$(sed 's/^0*//' <<< ${2})
		fi

		var_cs_url="$LIBRARY_URL${num}$CER"
	fi
elif [ ${1} == "standalone" ]; then
	if [ ${2} == "all" ]; then
		var_cs_url="$STANDALONE_URL$CER"
		#var_cs_url="http://192.168.128.243/bookserver/api/app-definitions/apple/?email=developers%40retrieve.com&authKey=9EmyAiRAIPciTh87PbAh%2FUlLAfwXrpl0NSl8IiB5APY%3D&libId=1"
	else
		var_cs_url="$STANDALONE_URL${2}$CER"
		#var_cs_url="http://192.168.128.243/bookserver/api/app-definitions/apple/${2}/?email=developers%40retrieve.com&authKey=9EmyAiRAIPciTh87PbAh%2FUlLAfwXrpl0NSl8IiB5APY%3D&libId=1"
	fi	
else
	echo "Please check you parameters."
fi

./grabCSJsonName.sh ${1} $var_cs_url ${2}


