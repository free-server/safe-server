#!/bin/bash

source /opt/.global-utils.sh

user=$1
pass=$2
shadowsocksRPort=$3
SPDYPort=$4


if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 SPDYName SPDYPassword SPDYPort"
  exit 0
fi

if [[ -z ${user} || -z ${pass} || -z ${shadowsocksRPort} || -z ${SPDYPort} ]]; then
  echoS "$0 user pass shadowsocksRPort SPDYPort"
  exit 1
fi

${binDir}/deleteuser-shadowsocks-r.sh "${shadowsocksRPort}" "${pass}"
${binDir}/deleteuser-spdy.sh "${user}" "${pass}" "${SPDYPort}"

if [[ ! -z ${isToInstallOcservCiscoAnyConnect} ]];then
    ${binDir}/deleteuser-ocserv.sh "${user}"
fi
