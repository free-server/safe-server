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

passwordBase64="$(echo ${password} | base64)"
obfuscateParamBase64="$(echo ${obfuscateParam} | base64)"
protocolParamBase64="$(echo ${protocolParam} | base64)"
remarkBase64="$(echo free-server:${freeServerName} | base64)"

ssrQrSchemeRaw=$(echo "${freeServerName}:${port}:${protocol}:${encrypt}:${obfuscate}:${passwordBase64}/?obfsparam=${obfuscateParamBase64}&protoparam=${protocolParamBase64}&remarks=${remarkBase64}&udpport=0&uot=0" | base64 -w 0)
ssrQrScheme=ssr://${ssrQrSchemeRaw}

echo "<hr /><br />\
<br />\nSSR info: \n<br />\
Host: ${freeServerName} \n<br />\
Port: ${port} \n<br />\
Password: ${password} \n<br />\
Obfuscate: ${obfuscate} \n<br />\
Protocol: ${protocol} \n<br />\
Encrypt: ${encrypt} \n<br />\n<br />\
<br />SSR Tutorial:\n<br />\n<br />\
https://${freeServerName}/#${ssrQrSchemeRaw}\n<br />\n\n<br /><hr />\
"

