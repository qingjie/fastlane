#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

echo "create - library ${1}  - `date`"

value=$(<temp-library.txt)
#echo "$value"
./create.sh library ${1} $value
echo ${1} > temp-library.txt
