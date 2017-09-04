#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 USERNAME PASSWORD PORT"
  exit 0
fi

if [[ ! -f ${SPDYConfig} ]]; then
  touch ${SPDYConfig}
  rm ${SPDYSquidPassWdFile}
  touch ${SPDYSquidPassWdFile}
fi

if [[ ! -f ${SPDYSquidPassWdFile} ]]; then
  touch ${SPDYSquidPassWdFile}
  rm ${SPDYConfig}
  touch ${SPDYConfig}
fi


if [[ ! -s ${letsEncryptKeyPath} ]]; then
  echoS "The SSL Key file ${letsEncryptKeyPath} is not existed. Exit" "stderr"
  sleep 2
  exit 0
fi


if [[ ! -f ${letsEncryptCertPath} ]]; then
  echoS "The SSL cert file ${letsEncryptCertPath} is not existed. Exit" "stderr"
  sleep 2
  exit 0
fi

username=$1
password=$2
port=$3

( [[ -z "${username}" ]]  || [[ -z "${password}" ]] || [[ -z "${port}" ]] ) \
 && echoS "You should invoke me via \`$0 USERNAME PASSWORD PORT \`. \
 None of the parameters could be omitted."  "stderr" \
 &&  sleep 2 && exit 0

if [[ ! -z $(gawk "/^${username},/ {print}" ${SPDYConfig}) ]]; then
  echoS "Ooops, the user ${username} is exited in file ${SPDYConfig} and ${SPDYSquidPassWdFile} already. Exit" "stderr"
  sleep 2
  exit 0
fi


if [[ ! -z $(gawk "/,${port}$/ {print}" ${SPDYConfig}) ]]; then
  echoS "Ooops, the port ${port} is taken in file ${SPDYConfig} already. Exit" "stderr"
  sleep 2
  exit 0
fi

newline=${username},${password},${port}

echo ${newline} >> ${SPDYConfig}

#spdyproxy -k ${letsEncryptKeyPath} -c ${letsEncryptCertPath} -p $port -U $username -P $password >/dev/null 2>&1  &


echo ${password} | htpasswd -i ${SPDYSquidPassWdFile} ${username}

#${binDir}/restart-spdy-squid.sh
${binDir}/restart-dead-spdy-nghttpx-squid.sh
#${binDir}/restart-spdy-nghttpx-squid.sh

echoS "SPDY account created with \n\
Username: $username \n\
Password: $password \n\
Port: $port \n\
"
