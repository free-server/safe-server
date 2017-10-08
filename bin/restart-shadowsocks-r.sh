#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0"
  exit 0
fi

cd ${shadowsocksRFolder}

portPasswordJson="{"
for i in $(cat "${shadowsocksRConfig}"); do
    port=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $1}')
    password=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $2}')
    protocol=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $3}')
    protocolParam=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $4}')
    obfuscate=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $5}')
    obfuscateParam=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $6}')

    portPasswordJson="${portPasswordJson} \"${port}\": {\n\
    \"password\":\"${password}\",\n\
    \"protocol\":\"${protocol}\",\n\
    \"protocol_param\":${protocolParam},\n\
    \"obfs\":\"${obfuscate}\",\n\
    \"obfs_param\":\"${obfuscateParam}\"\n\
    }, "
done
portPasswordJson=$(echo ${portPasswordJson} | sed -e 's/,$//g')

portPasswordJson="${portPasswordJson} }"



# writing to shadowsocks config file
#insertLineToFile ${configShadowsocks} "port_password" "\"$port\":\"$password\","
# more conf: https://doub.io/ss-jc11/
echo -e "{ \n\
\"server\": \"0.0.0.0\",\n\
\"timeout\":120,\n\
\"udp_timeout\":60,\n\
\"port_password\":${portPasswordJson},\n\
\"fast_open\":true,\n\
\"redirect\":[\"github.com\",\"awsmedia.s3.amazonaws.com\"],\n\
\"speed_limit_per_con\":${shadowsocksRSpeedPerCon},\n\
\"speed_limit_per_user\":${shadowsocksRSpeedPerUser},\n\
\"workers\":${shadowsocksRWorkerCount},\n\
\"method\":\"${shadowsocksREncrypt}\"\n \
}\
" > ${shadowsocksRConfigJson}

echo -e "Restarting all shadowsocks-R instances" | wall

killProcessesByPattern server.py > /dev/null 2>&1
python server.py -d stop > /dev/null 2>&1

sleep 2

python server.py -c ${shadowsocksRConfigJson} >> /dev/null 2&>1 &

isSSRRunning
