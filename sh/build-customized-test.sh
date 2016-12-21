rm -rf Builds

./bumpBuildNum.sh
./buildAndArchive-test.sh 2492
./buildAndArchive-test.sh 3072
#./buildAndArchive.sh 3074
#./buildAndArchive.sh 3141