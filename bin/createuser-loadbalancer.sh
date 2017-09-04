#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 PORT"
  exit 0
fi

#!/usr/bin/env bash

source /opt/.global-utils.sh

# clusterDefFilePath in /opt/.global-utils.sh

init() {
  port=$1

  generateConfig
  reloadLoadBalancer
  notifyUser
}

generateConfig() {
  config=${configDir}/haproxy.conf
  userConfig=${configDir}/haproxy-user.conf
  rm $userConfig_$port
  cp $userConfig $userConfig_$port
  #TODO dropped
}

reloadLoadBalancer() {
    ${binDir}/restart-dead-loadbalancer.sh
}

notifyUser() {
    echoS "Load Balancer created for Port: $port "
}

init "$@"




