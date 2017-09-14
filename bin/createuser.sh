#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 Username Pass ShadowsocksRPort SPDYPort"
  exit 0
fi

user=$1
pass=$2
shadowsocksRPort=$3
SPDYPort=$4

# both password and port should be given

( [[ -z "${user}" ]] || [[ -z "${pass}" ]] || [[ -z "${shadowsocksRPort}" ]] || [[ -z "${SPDYPort}" ]] ) \
 && echoS "You should invoke me via \`$0 Username Pass ShadowsocksRPort SPDYPort\`. All arguments could not be omitted." "stderr" && exit 0

${binDir}/createuser-shadowsocks-r.sh "${shadowsocksRPort}" "${pass}"
#${freeServerRoot}/createuser-spdy "${user}" "${pass}" "${SPDYPort}"
${binDir}/createuser-spdy-nghttpx-squid.sh "${user}" "${pass}" "${SPDYPort}"
#${freeServerRoot}/createuser-ipsec "${user}" "${pass}"

if [[ ! -z ${isToInstallOcservCiscoAnyConnect} ]];then
    ${binDir}/createuser-ocserv.sh "${user}" "${pass}"
fi

echoS "All done. HTTP2/SPDY, Shadowsocks-R account has been created for user $user"

echoS "================================================================================"
echo ""
echo "Next Step: Setup Tutorial for HTTP2"
echo ""
echo ""
echo "Tutorial WebLink:"
echo ""
echo "${httpsFreeServerUrl}/#http2"
echo ""
echoS "================================================================================"