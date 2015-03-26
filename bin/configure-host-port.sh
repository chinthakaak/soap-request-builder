#!/bin/bash
. project.properties

#echo $proxyserver
#echo $proxyport
#echo $proxyenabled

echo Configuring host to $host:$port
cp conf/original/ws.list conf/
sed -i 's/@host@/'$host'/g; s/@port@/'$port'/g;' conf/ws.list
