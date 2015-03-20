#!/bin/bash

#if [ $# == 0 ]; then echo "SOAP Endpoint address is missing"; exit 0; fi

echo "Generating requests for SOAP Endpoint addresses..."

#endpoints=( $( cat "conf/ws.list" ) )

while read -r url || [[ -n $url ]];
do
    list+=$url" "
    echo "Text read from file - $url"
done < "conf/ws.list"

rm -rf requests/*
java -jar bin/wsdl-utils-1.0.jar $list
