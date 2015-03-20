#!/bin/bash

#if [ $# == 0 ]; then echo "SOAP Endpoint address is missing"; exit 0; fi



for i in `ls scripts`;
    do
        for j in `ls scripts/$i/*.sh`;
            do
                cp template-scripts/templateService/script-template.sh $j;
                f=`basename $j .sh`;
                if [ ! -f scripts/$i/data/$f.index ];
                    then
                        touch scripts/$i/data/$f.index;
                        echo 0 > scripts/$i/data/$f.index;
                fi

            done
    done