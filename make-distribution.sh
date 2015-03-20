#!/bin/bash
./local-clean-install.sh

DIST_LOCATION=target/layout/dist

rm -rf $DIST_LOCATION
mkdir -p $DIST_LOCATION/temp

cp -r bin  $DIST_LOCATION/temp

cp -r lib $DIST_LOCATION/temp

cp -r template-scripts $DIST_LOCATION/temp

cp -r conf $DIST_LOCATION/temp

mkdir $DIST_LOCATION/temp/requests

mkdir $DIST_LOCATION/temp/scripts

cp install.sh $DIST_LOCATION/temp

cp clean.sh $DIST_LOCATION/temp

cd $DIST_LOCATION/temp

tar -zcvf  ../soap-request-builder-1.0.tar.gz .

echo
echo "soap-request-builder distribution is available at `pwd`$DIST_LOCATION"
echo