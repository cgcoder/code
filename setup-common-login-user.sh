#!/bin/bash

function print_help_exit {
   echo 'Help text'
   exit 4
}

#print_help_exit

HOSTS=()
USER=`whoami`
LOGIN_USER=`whoami`

while getopts ":l:h:u:g" ARG; do
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
HOST=`hostname`

for HOST in ${HOSTS[@]}; do
    echo "Creating ssh key for $USER@$HOST"
    ssh -t $USER@$HOST "ssh-keygen -t rsa -b 4096"
    for HOST2 in ${HOSTS[@]}; do
        echo "Copying ssh public key for $USER@$HOST2"
        ssh -t $USER@$HOST "ssh-copy-id -i ~/.ssh/id_rsa.pub $USER@$HOST2"
    done
done
