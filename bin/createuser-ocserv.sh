#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 USERNAME PASSWORD"
  exit 0
fi


if [[ ! -f ${ocservPasswd} ]]; then
  echoS "Ocserv Password file (${ocservPasswd}) is not detected. This you may not install it correctly. Exit." "stderr"
  sleep 2
  exit 1
fi

username=$1
password=$2

( [[ -z "${username}" ]]  || [[ -z "${password}" ]] ) \
 && echoS "You should invoke me via \`$0 USERNAME PASSWORD \`. \
 None of the parameters could be omitted." "stderr" \
 && sleep 2 && exit 0

if [[ ! -z $(gawk "/^${username}:/ {print}" ${ocservPasswd}) ]]; then
  echoS "Ooops, the user ${username} is exited in file ${ocservPasswd} already. Exit" "stderr"
  sleep 2
  exit 0
fi


echo "$password" | ocpasswd -c ${ocservPasswd} $username


echoS "Ocserv / Cisco AnyConnect account created with \n\n\
Username: $username \n\
Password: $password \n\n\
in file ${ocservPasswd} \n\
"
