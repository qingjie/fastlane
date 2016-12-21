#!/bin/sh

pushd `dirname $0` > /dev/null
./_buildAndArchiveCommon.sh "$1" "Release Demo" "$2"
