#!/bin/sh

pushd `dirname $0` > /dev/null
echo "\033[0;41mBuilding for production\033[0m"
./_buildAndArchiveCommon.sh "$1" "Release Production" "$2"