#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail
APP_CS_TARGET="../../targets/${1}"

echo " *************** start to parse ${1} at `date` *************** "


if [ ${2} == "all" ]; then
	for f_target in $APP_CS_TARGET/*.json
	do
	filename=$(basename "$f_target")
	fname="${filename%.*}"
	echo $fname
	if [ $fname != "standalone" ] || [ $fname != "library" ] ; then
		./parseJson.sh ${1} $fname
		echo $fname
	fi
	done

else
	./parseJson.sh ${1} ${2}
fi


echo " *************** end to parse ${1}  at `date` *************** "

