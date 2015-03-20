#!/bin/bash

#if [ $# == 0 ]; then echo "SOAP Endpoint address is missing"; exit 0; fi

echo "Copying request files..."

for i in `ls requests`;
    do
        if [ ! -d scripts/$i/data ]; then mkdir scripts/$i/data;fi;
        cp requests/$i/* scripts/$i/data;
    done

