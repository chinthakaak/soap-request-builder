#!/bin/bash

#if [ $# == 0 ]; then echo "SOAP Endpoint address is missing"; exit 0; fi

#echo "Generating requests for shell scripts : $1"
#echo ${a##*consumeCredits}
#a=/soapenv:Envelope/soapenv:Body/acc:consumeCredits/callContext/additionalContext/additionalContext/tag

echo "Generating xpaths for all requests..."

for i in `ls requests`;
    do
        for j in `ls requests/$i`;
            do
                f=`basename $j .xml`;
#                touch "scripts/$i/$f.sh";
#                chmod +x scripts/$i/$f.sh;
                xmlstarlet tr conf/transformer.xsl scripts/$i/data/$f.xml > scripts/$i/data/$f.xall
                if [ ! -f scripts/$i/data/$f.xmin ]; then touch scripts/$i/data/$f.xmin;fi
            done
    done

#while read -r xpath || [[ -n $xpath ]];
#do
#
#    echo $xpath
#done < "scripts/accountManagement/data/consumeCredits.xml"
#
#for i in `ls requests`;
#    do
#        mkdir scripts/$i;
#        mkdir scripts/$i/data;
#        cp requests/$i/* scripts/$i/data;
#    done

