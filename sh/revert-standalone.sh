#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

echo "revert - standalone ${1}  - `date`"

value=$(<temp-standalone.txt)
#echo "$value"
./resume.sh standalone $value ${1}
echo ${1} > temp-standalone.txt
