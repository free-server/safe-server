#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0"
  exit 0
fi

exitOnFreeServerUpdating

cd ${shadowsocksRFolder}

isSSRRunning
isSSRRunningCheckingCode=$?

if [[ ${isSSRRunningCheckingCode} == 1 ]]; then
    echo -e "Restart SSR with $shadowsocksRConfigJson" | wall
    python server.py -c ${shadowsocksRConfigJson} >> /dev/null 2&>1 &
fi

#
#shadowsocksRConfigList=$(find ${configDir} -name "ssr-*.json")
#
#for configFile in ${shadowsocksRConfigList}; do
#  isProcessRunning=$(ps aux | awk '$0~v' v="-c\\ ${configFile}")
#  if [[ -z ${isProcessRunning} ]]; then
#    echo -e "Restart SSR with $configFile" | wall
#    python server.py -c ${configFile} >> /dev/null 2&>1 &
#
#  else
#    echo "Skipped $i since it is already stated. Process: ${isProcessRunning}"
#  fi
#
#done

isSSRRunning
