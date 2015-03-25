#!/bin/bash
. project.properties

#echo $proxyserver
#echo $proxyport
#echo $proxyenabled

echo Configuring proxy to $proxyserver:$proxyport $proxyenabled
cp conf/original/settings.xml conf/
sed -i 's/@proxyserver@/'$proxyserver'/g; s/@proxyport@/'$proxyport'/g; s/@proxyenabled@/'$proxyenabled'/g; s/@bypassproxy@/'$bypassproxy'/g;' conf/settings.xml
