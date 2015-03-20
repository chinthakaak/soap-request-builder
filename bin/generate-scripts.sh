#!/bin/bash

#if [ $# == 0 ]; then echo "SOAP Endpoint address is missing"; exit 0; fi

echo "Generating shell scripts..."

for i in `ls requests`;
    do
        if [ ! -d scripts/$i ]; then mkdir scripts/$i;fi
#        mkdir scripts/$i;
#        mkdir scripts/$i/data;
        for j in `ls requests/$i`;
            do
                f=`basename $j .xml`;
                touch "scripts/$i/$f.sh";
                chmod +x scripts/$i/$f.sh;
            done
    done

