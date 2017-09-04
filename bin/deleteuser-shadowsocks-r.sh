#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 PORT"
  exit 0
fi

port=$1
pass=$2

if [[ -z ${port} || -z ${pass}  ]]; then
  echoS "$0 PORT PASSWORD"
  exit 1
fi


# new delete
removeLineInFile  ${shadowsocksRConfig} "${port},${pass}"

echoS "SSR deleted for Port ${port} from ${shadowsocksRConfig}"

${binDir}/restart-shadowsocks-r.sh

