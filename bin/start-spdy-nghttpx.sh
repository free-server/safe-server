#!/bin/bash

source /opt/.global-utils.sh

frontConfigList=$1

main() {
  showHelp
  commonCheck
  startNgHttpX
}

showHelp() {
  if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
  then
    echo "Usage: $0 FRONTEND_LISTEN_PORT"

    exit 0
  fi
}

commonCheck() {
  if [[ ! -s ${SPDYConfig} ]]; then
    echoS "The HTTP2 config file ${SPDYConfig} is not found . Exit" "stderr"
    exit 1
  fi

  if [[ ! -s ${letsEncryptKeyPath} ]]; then
    echoS "The SSL Key file ${letsEncryptKeyPath} is not existed. Exit" "stderr"
    exit 1
  fi


  if [[ ! -s ${letsEncryptCertPath} ]]; then
    echoS "The SSL cert file ${letsEncryptCertPath} is not existed. Exit" "stderr"
    exit 1
  fi

  if [[ -z $frontConfigList ]]; then
    echo "Usage: $0 FRONTEND_LISTEN_CONFIG"
    exit 1
  fi

}


startNgHttpX() {
  #--read-rate=${nghttpxUploadLimit} \
#  --write-rate=${nghttpxDownloadLimit} \


  pkill nghttpx

  startCommand="nghttpx \
  --workers=${nghttpxWorkerCount} \
  ${frontConfigList} \
  --daemon \
  --http2-proxy \
  --frontend-http2-max-concurrent-streams=${SPDYNgHttpXConcurrentStreamAmount} \
  --backend=\"${SPDYForwardBackendSquidHost},${SPDYForwardBackendSquidPort}\" \
  \"${letsEncryptKeyPath}\" \"${letsEncryptCertPath}\""

#  startCommond="nghttpx \
#  --daemon \
#  --http2-proxy \
#  --frontend=\"${SPDYFrontendListenHost},${port}\" \
#  --frontend-http2-max-concurrent-streams=${SPDYNgHttpXConcurrentStreamAmount} \
#  --backend=\"${SPDYForwardBackendSquidHost},${SPDYForwardBackendSquidPort}\" \
#  \"${letsEncryptKeyPath}\" \"${letsEncryptCertPath}\""

  eval ${startCommand} > /dev/null 2>&1

}

main "$@"