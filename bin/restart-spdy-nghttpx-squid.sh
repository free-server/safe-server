#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "Usage: $0"

  exit 0
fi

if [[ ! -f ${SPDYConfig} ]]; then
  echoS "The SPDY config file ${SPDYConfig} is not found . Exit" "stderr"
  exit 0
fi

if [[ ! -s ${letsEncryptKeyPath} ]]; then
  echoS "The SSL Key file ${letsEncryptKeyPath} is not existed. Exit" "stderr"
  exit 0
fi


if [[ ! -s ${letsEncryptCertPath} ]]; then
  echoS "The SSL cert file ${letsEncryptCertPath} is not existed. Exit" "stderr"
  exit 0
fi

pkill ^nghttpx

${binDir}/restart-spdy-squid.sh

${binDir}/restart-dead-spdy-nghttpx-squid.sh

