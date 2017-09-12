#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 PORT PASSWORD [ENCRYPT_METHOD] [OBFUSCATE_METHOD] [PROTOCOL_METHOD] [OBFUSCATE_PARAM] [PROTOCOL_PARAM]"
  exit 0
fi

port=$1
password=$2

protocol=$3
protocolParam=$4

# https://github.com/breakwa11/shadowsocks-rss/blob/master/ssr.md
obfuscate=$5
obfuscateParam=$6




# both password and port should be given

( [[ -z "${password}" ]] || [[ -z "${port}" ]] ) && echoSExit "you should invoke me via \`$0 PASSWORD PORT \`. \
 None of the parameters could be omitted." "stderr" \
 && exit 0


if [ -z ${encrypt} ]; then
  encrypt=${shadowsocksREncrypt}
fi

if [ -z ${obfuscate} ]; then
#  encrypt="http_simple"
  obfuscate=${shadowsocksRObfuscate}
fi


if [ -z ${protocol} ]; then
#  encrypt="http_simple"
  protocol=${shadowsocksRProtocol}
fi

if [ -z ${protocolParam} ]; then
#  encrypt="http_simple"
  protocolParam=${shadowsocksRProtocolParam}
fi

if [ -z ${obfuscateParam} ]; then
#  encrypt="http_simple"
  obfuscateParam=${shadowsocksRObfuscateParam}
fi


if [[ ! -f ${shadowsocksRConfig} ]]; then
  touch ${shadowsocksRConfig}
fi


if [[ ! -z $(gawk "/^${port},/ {print}" ${shadowsocksRConfig}) ]]; then
  echoS "Ooops, the port ${port} is taken in file ${shadowsocksRConfig} already. Exit" "stderr"
  sleep 2
  exit 0
fi

if [[ ! -z $(gawk "/,${password},/ {print}" ${shadowsocksRConfig}) ]]; then
  echoS "Ooops, the user ${password} is exited in file ${shadowsocksRConfig} already. Exit" "stderr"
  sleep 2
  exit 0
fi

newline=${port},${password},${protocol},${protocolParam},${obfuscate},${obfuscateParam}

echo ${newline} >> ${shadowsocksRConfig}


${binDir}/restart-shadowsocks-r.sh


passwordBase64="$(echo ${password} | base64)"
obfuscateParamBase64="$(echo ${obfuscateParam} | base64)"
protocolParamBase64="$(echo ${protocolParam} | base64)"
remarkBase64="$(echo free-server:${freeServerName} | base64)"

ssrQrSchemeRaw=$(echo "${freeServerName}:${port}:${protocol}:${encrypt}:${obfuscate}:${passwordBase64}/?obfsparam=${obfuscateParamBase64}&protoparam=${protocolParamBase64}&remarks=${remarkBase64}&udpport=0&uot=0" | base64 -w 0)
ssrQrScheme=ssr://${ssrQrSchemeRaw}

echoS "Shadowsocks-R account created. \n\
Port: ${port} \n\
Password: ${password} \n\
Obfuscate: ${obfuscate} \n\
Protocol: ${protocol} \n\
Encrypt: ${encrypt} \n\n\
Starting SSR instance...\
"

echoS "================================================================================"
echo ""
#echo "SSR QR Scheme (For generating SSR QR Code):"
#echo ""
#echo ${ssrQrScheme}
#echo ""
echo ""
echo "SSR QR Code WebLink:"
echo ""
echo "https://${freeServerName}/#${ssrQrSchemeRaw}"
echo ""
echoS "================================================================================"

