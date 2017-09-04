#!/bin/bash

source /opt/.global-utils.sh

username=$1

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 username"
  exit 0
fi

if [[ -z ${username} ]]; then
  echoS "$0 username"
  exit 1
fi

removeLineInFile  ${ocservPasswd} "${username}:"

echoS "Ocserv / OpenConnect / Cisco AnyConnect VPN account deleted for ${username} from ${ocservPasswd}"
