#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

echo "create - standalone ${1}  - `date`"

value=$(<temp-standalone.txt)
#echo "$value"
./create.sh standalone ${1} $value
echo ${1} > temp-standalone.txt
