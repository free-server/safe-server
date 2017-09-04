#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "Usage: $0"

  exit 0
fi

if [[ ! -s ${letsEncryptKeyPath} ]]; then
  echoS "The SSL Key file ${letsEncryptKeyPath} is not existed. Exit" "stderr"
  exit 1
fi


if [[ ! -s ${letsEncryptCertPath} ]]; then
  echoS "The SSL cert file ${cerletsEncryptCertPatht} is not existed. Exit" "stderr"
  exit 1
fi

if [[ ! -f ${ocservConfig} ]]; then
    echoS "Ocserv config file (${ocservConfig}) is not detected. This you may not install it correctly. Exit." "stderr"
    exit 1
fi

if [[ ! -f ${ocservPasswd} ]]; then
    echoS "Ocserv Password file (${ocservPasswd}) is not detected. This you may not install it correctly. Exit." "stderr"
    exit 1
fi

# set iptable to connecto Internet
enableIptableToConnectInternet

# kill and start
pkill -ef ^ocserv
sleep 2

${binDir}/restart-dead-ocserv.sh

echoS "Restarted ocserv"
sleep 1
