#!/bin/bash

source /opt/.global-utils.sh

user=$1
pass=$2
shadowsocksRPort=$3
SPDYPort=$4
emailAddress=$5


if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 HTTP2Name HTTP2Password HTTP2Port EmailAddress"
  exit 0
fi

if [[ -z ${user} || -z ${pass} || -z ${shadowsocksRPort} || -z ${SPDYPort} ]]; then
  echoS "$0 user pass shadowsocksRPort HTTP2Port EmailAddress"
  exit 1
fi

if [[ -z "$emailAddress" ]];then
  emailAddress=${freeServerUserEmail}
fi

${binDir}/deleteuser-shadowsocks-r.sh "${shadowsocksRPort}" "${pass}"
${binDir}/deleteuser-spdy.sh "${user}" "${pass}" "${SPDYPort}"

if [[ ! -z ${isToInstallOcservCiscoAnyConnect} ]];then
    ${binDir}/deleteuser-ocserv.sh "${user}"
fi

mailNotify "Safe server user is deleted for ${user}" "User ${user} is deleted for ${emailAddress}" "${emailAddress}"