#!/bin/bash

#if [ $# == 0 ]; then echo "SOAP Endpoint address is missing"; exit 0; fi

errorhandler(){

    printf "${RED}${b}@Line:$1 - Error in $0 - Exit code = $2 ${NONE}\n";

    exit
}

trap 'errorhandler ${LINENO} ${$?}'  err #exit #err #1 2 3

bname=`basename $0 .sh`

declare -i linecount=0;

b=`tput bold`
n=`tput sgr0`
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
BLUE='\033[01;34m'

#sleep 2

sendrequest(){
    trap 'errorhandler ${LINENO} ${$?}'  err
    #. script-template.xmin
    declare -A arr

    # read file line by line and populate the array
    while IFS='=' read -r k v; do
       arr["$k"]="$v"
    done < data/$bname.xmin


    # Read all xpaths to an allarray
    declare -A allarray;
    declare -A removearray;

    while IFS='=' read -r k v; do
        allarray["$k"]="$v"
        removearray["$k"]="$v"

    done < data/$bname.xall

    # Read min xpaths to an minarray
    declare -A minarray;

    while IFS='=' read -r k v; do
#        echo "${#minarray[@]}"

            duplicatekyefound=false
            for m in "${!minarray[@]}"
                do
                    if [[ $m == $k ]];
                         then
                            minarray["$k"]="${minarray[$m]}|$v"
#                            echo $k
#                            echo ${minarray["$k"]}
                            duplicatekyefound=true
                    fi

                done
            if [ $duplicatekyefound == false ];
             then
                minarray["$k"]="$v"
#                echo test
            fi
    done < data/$bname.xmin



    # Get unwanted xpaths to an removearray = allarray-minarray

    for i in "${!allarray[@]}"
      do
#	    echo all array $i
        for j in "${!minarray[@]}"

        do
#        echo min arra $j;
            if [[ $i == $j ]];
             then
                #echo unsetting removearray[$i]
                unset removearray[$i];
            fi
        done
      done
#    for j in "${!removearray[@]}"
#      do
#        echo $j ${removearray[$j]}
#      done
    # Copy template.xml to template-sent.xml
    cp data/$bname.xml data/$bname-sent.xml

    # Remove unwanted xml tags from template-sent.xml using removearray
#    echo remove array
    for i in "${!removearray[@]}"
      do
#      echo ${removearray[$i]}
#      echo $i
        xmlstarlet ed -L -d $i data/$bname-sent.xml
      done

    # Delete splitted nodes with ?- tag, value AND Delete splitted nodes level 2 - additionalContext
    declare -A splitarray;
    for i in "${!minarray[@]}"
        do
            IFS='|' read -ra splits <<< "${minarray[$i]}"

            if [ ${#splits[@]} -gt 1 ];
                then
                 xp1=${i%/*};
                 echo $xp1

                 xmlstarlet ed -L -d $i data/$bname-sent.xml
                 xmlstarlet ed -L -d $xp1 data/$bname-sent.xml

                 splitarray["$xp1"]="${#splits[@]}"
            fi
        done

    # Add requied num of level 2 nodes
    echo ${splitarray[xp1]}
    echo $xp1
    for i in "${!splitarray[@]}"
        do
            for ((j=0 ; j<${splitarray[$i]}; ++j));
                do
                    echo test ${i%/*} ${i##*/}
                    xmlstarlet ed -L -s ${i%/*} -t elem -n ${i##*/} -v "" data/$bname-sent.xml
                done
        done

    # Add required num of level 1 nodes and values


    # Update template-sent.xml with minarray values
#    echo min array
#    for i in "${!minarray[@]}"
#      do
##        echo ${minarray[$i]}
##        echo $i
##        splits=(${minarray[$i]//\|/ })
#        IFS='|' read -ra splits <<< "${minarray[$i]}"
#
#        xp1=${i%/*};
#        xp1v=${i##*/}
#
#        xp2=${xp1%/*}
#        xp2v=${xp1##*/}
#
#        echo $xp1 $xp1v
#        echo $xp2 $xp2v
#
##        echo ${#splits[@]}
#        if [ ${#splits[@]} -gt 1 ];
#            then
##                echo ${#splits[@]}
##                echo ${i##*/}
##                echo ${i%/*}
#
#
#
#                xmlstarlet ed -L -d $i data/$bname-sent.xml
#                #xmlstarlet ed -L -d $xp1 data/$bname-sent.xml
#
#                #xmlstarlet ed -L -s $xp2 -t elem -n $xp2v -v "" data/$bname-sent.xml
#                #xmlstarlet ed -L -s $xp2 -t elem -n $xp2v -v "" data/$bname-sent.xml
#
#                xmlstarlet ed -L -s $xp1 -t elem -n $xp1v -v x data/$bname-sent.xml
##                xmlstarlet ed -L -s $xp1[2] -t elem -n $xp1v -v y data/$bname-sent.xml
##
##                xmlstarlet ed -L -s $xp1[1] -t elem -n $xp1v -v x data/$bname-sent.xml
##                xmlstarlet ed -L -s $xp1[2] -t elem -n $xp1v -v y data/$bname-sent.xml
#
#                for split in ${splits[@]}
#                    do
##                        echo ${i##*/}
##                        echo ${i%/*}
#                        echo $split
##                         xmlstarlet ed -L -s ${i%/*} -t elem -n ${i##*/} -v $split data/$bname-sent.xml
#
##                          xmlstarlet ed -L -s $xp1 -t elem -n $xp1v -v $split data/$bname-sent.xml
#                    done
#
#            else
#                xmlstarlet ed -L -u $i -v "${minarray[$i]}" data/$bname-sent.xml
#        fi
#      done

    # Update soap request-sent with new indexes

    sed -i 's/@index/'$newindex'/g' data/$bname-sent.xml

    # Send the soap request using curl
    while read -r url || [[ -n $url ]];
    do
        result=${PWD##*/};
        if [[ $url == *"$result"* ]];
        then
            curl -d @data/$bname-sent.xml $url > data/$bname-response.xml -H "Content-Type:text/xml"
            xmlstarlet tr ../../conf/nsremove.xsl data/$bname-response.xml > data/$bname-response-nons.xml

            xmlstarlet tr ../../conf/transformer.xsl data/$bname-response-nons.xml > data/$bname-response.xall
            linecount=1;
            printf "\n"
            printf "Response Data - All\n";
            printf "===================\n"
            while IFS= read -r line; do
                value=`xmlstarlet sel -T -t -c $line data/$bname-response-nons.xml`
                printf "$linecount.${GREEN}${b} ${line##*$bname}=${BLUE}$value${n}${NONE}\n";
                linecount+=1;
            done < data/$bname-response.xall
        fi
    done < "../../conf/ws1.list"

    ## Restore backups if any
    if [[  ${#qarray[@]} > 0 && ${#qarray[@]} -eq $qlcount ]];
        then
            cp data/$bname.xmin.back data/$bname.xmin
            rm -rf data/$bname.xmin.back
    fi
}

printall(){

    declare -i linecount=0;
    printf "\n"
    printf "Request Data - All\n";
    printf "==================\n"
    while read -r xpath || [[ -n $xpath ]];
        do
            linecount+=1;

            printf "$linecount.${GREEN}${b} ${xpath##*$bname}${n}${NONE}\n";
        done < "data/$bname.xall"
}

printadded(){

    declare -i linecount=0;
    printf "\n"
    printf "Request Data - Sent\n"
    printf "===================\n"
    while read -r xpath || [[ -n $xpath ]];
        do
            linecount+=1;

            printf "$linecount.${BLUE}${b} ${xpath##*$bname}${n}${NONE}\n";
        done < "data/$bname.xmin"
}

printsent(){

    declare -i linecount=0;
    printf "\n"
    printf "Request Data - Sent\n"
    printf "===================\n"
    # for index replcament
    oldindex=$(sed -n 1p data/$bname.index);
    newindex=$(( $oldindex + 1 ))
    echo $newindex > data/$bname.index
    cat data/$bname.xmin |sed 's/@index/'$newindex'/g'
    echo
}

main(){
    qarray=();
	while [ "$1" != "" ]; do
	    case $1 in
		-add )
            shift

            printall $@
            printadded $@

            if [[ $1 == [0-9]* ]];
                then
                    while [[ $1 == [0-9]* ]]; do
        #				addarray+=($1);
                        line=$(sed -n ${1%%=*}p data/$bname.xall);
                        if [[ $1 == *"="* ]];
                            then
                                echo $line=${1##*=} >> data/$bname.xmin
                            else
                                echo $line >> data/$bname.xmin
                        fi
                        shift;
                    done
                printadded $@
            fi
            exit 0;

#
#			echo ${addarray[@]}
		        ;;

		-del* )
		    shift

            printall $@

            if [[ $1 == [0-9]* ]];
                then
                    dellines=`echo $@ |sed -e 's/ /d;/g'`
                    sed -i $dellines'd' data/$bname.xmin
            fi

            printadded $@
            exit 0;
		        ;;

		-mod* )
		    shift

            printadded $@
            if [[ $1 == [0-9]* ]];
                then
                    while [[ $1 == [0-9]* ]]; do
        #				addarray+=($1);
                        line=$(sed -n ${1%%=*}p data/$bname.xmin);

                        if [[ $1 == *"="* ]];
                            then
#                                echo updating ${1%%=*}
#                                echo $line
#                                k=$line=${1##*=}
#                                echo $k
                                if [[ $line == *"="* ]];
                                    then
                                        sed -i "${1%%=*}s/=.*/=${1##*=}/" data/$bname.xmin
                                    else
                                        sed -i "${1%%=*}s/$/=${1##*=}/" data/$bname.xmin
                                fi
                        fi
                        shift;
                    done
                printadded $@
            fi
            exit 0;
		;;

		-l)
		    shift
            printall $@
		    printadded $@
		    exit 0;
		;;

		* )
#		    echo $1
		    qarray+=("$1");
		    shift
		    ;;

	    esac
	done
}

validaterequest(){
    ## Showing xpaths to the user and validate
    echo
    printf "Request Validation\n";
    printf "==================\n"
    xpathsvalid=true;

    while read -r xpath || [[ -n $xpath ]];
    do
        linecount+=1;

        if [[ $xpath == *"="[0-9a-zA-Z@]* ]]
            then
                printf "$linecount.${GREEN}${b} ${xpath##*$bname}${n}${NONE}\n";
                #        printf $(cat "data/$bname.index")
              elif [[ $xpath == *"="[?] ]];
                then
                    printf "$linecount.${BLUE}${b} ${xpath##*$bname}${n}${NONE}\n";
                else
                    printf "$linecount.${RED}${b} ${xpath##*$bname}${n}${NONE}\n";
                    xpathsvalid=false;
            fi
    done < "data/$bname.xmin"

    ## xpath validation process
    if [[ $xpathsvalid == true ]]
    then
        echo
        printf "Xpath validation is successful\n"
        echo
    else
        echo
        printf "${RED}${b}RED${n}${NONE} colored xpaths have not been set correctly\n"
        echo
        exit 2;
    fi

    # Count number of ? s
    qlcount=0;

    linecount=`wc -l < data/$bname.xmin`

    for (( i=1 ; i<=$linecount; i++));
    do
        line=$(sed -n ${i}p data/$bname.xmin);

#        echo "${line##*=}";
        if [ "${line##*=}" == ? ];
            then
                qlcount=$((qlcount+1))

        fi
    done

#    echo ${#qarray[@]}
    if [[  ${#qarray[@]} > 0 && ${#qarray[@]} -eq $qlcount ]];
#    if [ ${#qarray[@]} -eq $qlcount ];
        then
            # back up xmin files
            cp data/$bname.xmin data/$bname.xmin.back

            linecount=`wc -l < data/$bname.xmin`

            qarrayindex=0;
            for (( i=1 ; i<=$linecount; i++));
            do

                line=$(sed -n ${i}p data/$bname.xmin);
#                echo ${line##*=}

                if [ "${line##*=}" == ? ];
                    then
#                        ./$bname.sh -mod ''$i'='${qarray[$i - 1]}''
                        sed -i "${i}s/?$/${qarray[$qarrayindex]}/" data/$bname.xmin
                        qarrayindex=$((qarrayindex+1));
                fi
            done
            printsent $@
            else
                printsent $@
    fi
}



# add modify delete option processing
main "$@"


# Check for no param execution and do request send
#if [ $# == 0 ];
#    then
validaterequest "$@"
sendrequest "$@"


#fi

