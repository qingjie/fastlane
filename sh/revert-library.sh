#!/bin/bash

# stop on all failures (http://redsymbol.net/articles/unofficial-bash-strict-mode/)
set -euo pipefail

echo "revert - library ${1}  - `date`"

value=$(<temp-library.txt)
#echo "$value"
./resume.sh library $value ${1}
echo ${1} > temp-library.txt
