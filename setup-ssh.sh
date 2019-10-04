#!/bin/bash

function print_help_exit {
   echo 'Help text'
   exit 4
}

#print_help_exit

HOSTS=()
USER="hadoop"
while getopts ":h:u:" ARG; do
    case ${ARG} in
        h )
            IFS=','
            read -ra HOSTS <<< "${OPTARG}"
        ;;
        u )
            USER="${OPTARG}"  
        ;;
    esac
done
shift $((OPTIND - 1))

for HOST in "${HOSTS[@]}"; do
    ssh-keygen -t rsa -b 4096
    for OTHER_HOST in "${HOSTS[@]}"; do
        if [ ! "$OTHER_HOST" = "$HOST" ] 
        then
            echo "Copying public key of $HOST to $OTHER_HOST for user $USER"
            ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@$OTHER_HOST
        fi
    done
done

