#!/bin/bash
bname=`basename $0 .sh`

b=`tput bold`
n=`tput sgr0`
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
BLUE='\033[01;34m'

printall(){
        if [ $# == 0 ];
            then
                declare -i linecount=0;
                printf "\n"
                printf "All available request parameters\n";
                printf "================================\n"
                while read -r xpath || [[ -n $xpath ]];
                    do
                        linecount+=1;

                        printf "$linecount.${GREEN}${b} ${xpath##*$bname}${n}${NONE}\n";
                    done < "data/$bname.xall"
        fi;
}

printadded(){
        if [ $# == 0 ];
            then
                declare -i linecount=0;
                printf "\n"
                printf "Added request parameters\n"
                printf "========================\n"
                while read -r xpath || [[ -n $xpath ]];
                    do
                        linecount+=1;

                        printf "$linecount.${BLUE}${b} ${xpath##*$bname}${n}${NONE}\n";
                    done < "data/$bname.xmin"
        fi;
}

main(){
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

#
#			echo ${addarray[@]}
		        ;;

		-del* )
		    shift

            printall $@
            printadded $@

            if [[ $1 == [0-9]* ]];
                then
                    while [[ $1 == [0-9]* ]]; do
        #				addarray+=($1);
                        sed -i $1d data/$bname.xmin
                        shift;
                    done
                printadded $@
            fi
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
                                        sed -i ''${1%%=*}'s/=.*/='${1##*=}'/' data/$bname.xmin
                                    else
                                        sed -i ''${1%%=*}'s/$/='${1##*=}'/' data/$bname.xmin
                                fi
                        fi
                        shift;
                    done
                printadded $@
            fi
		;;

		-l)
		    shift

		    printadded $@
		;;

		* ) echo invalid
			shift

	    esac
	done
}

main $@