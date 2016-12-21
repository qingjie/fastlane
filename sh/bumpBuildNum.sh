#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

CLR_BLUE="\033[0;36m"
CLR_RED="\033[0;41m"
CLR_NORMAL="\033[0m"

pushd `dirname $0` > /dev/null
OWN_DIR=`pwd`
branch_name=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
popd > /dev/null

CONF_FILE=$OWN_DIR/../RetrieveApp/Config/BuildNumber.xcconfig
TMP_CONF_FILE=${CONF_FILE}.tmp
echo $CONF_FILE
#${BUILD_NUMBER} is jenkins number, we can use jenkins nuber or self design.
#perl -pe "\$_=~s/(RTI_PRODUCT_BUILD = )([0-9]+)(;)/\$1.(${BUILD_NUMBER}).\$3/e;" < "$CONF_FILE" > "$TMP_CONF_FILE"
perl -pe "\$_=~s/(RTI_PRODUCT_BUILD = )([0-9]+)/\$1.(\$2+1).\$3/e;" < "$CONF_FILE" > "$TMP_CONF_FILE"
mv "$TMP_CONF_FILE" "$CONF_FILE"
grep -m 2 RTI_PRODUCT "$CONF_FILE"
build_num=`perl -lne 'print $& if /(?<=RTI_PRODUCT_BUILD = )(\d+)/' "$CONF_FILE"`
if [[ "$build_num" == ""  ||  "$build_num" -le "10" ]]; then
	echo -e "${CLR_RED}ERROR: Could not extract the build number${CLR_NORMAL}"
	exit 1
fi

echo -e "Successfully incremented build number to $CLR_BLUE$build_num$CLR_NORMAL"

if [ "${1-}" == "autocommit" ]; then
  git add $CONF_FILE
  git commit -m "Changed build number to $build_num"
  echo Git Branch: $branch_name
  #git push origin $branch_name
  git push origin HEAD
fi
