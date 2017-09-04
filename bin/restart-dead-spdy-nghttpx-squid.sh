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

runCommandIfPortClosed "${SPDYForwardBackendSquidPort}"  "${binDir}/restart-spdy-squid.sh"


for i in $(cat "${SPDYConfig}"); do
    port=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $3}')
    frontConfigList=" ${frontConfigList} --frontend='${SPDYFrontendListenHost},${port}' "
done


for i in $(cat "${SPDYConfig}"); do

  username=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $1}')
  password=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $2}')
  port=$(echo "$i" | gawk 'BEGIN { FS = "," } ; {print $3}')


  if [[ -z ${username} || -z ${password} || -z ${port} ]]; then
    echoS "username, password and port are all mandatory \n\
    username: ${username} \n\
    password: ${password} \n\
    port: ${port} \n"
  else

    runCommandIfPortClosed "${port}" "${binDir}/start-spdy-nghttpx.sh \"${frontConfigList}\";  echo \"Restart HTTP2/SPDY with ${username}, ${port}\""

  fi

done



