#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "Usage: $0"

  exit 0
fi
echoS "Restart SPDY Squid3"
killall squid3
killall squid

squid3 -k  kill

squid3 -z
squid3 -z -f ${SPDYSquidConfig}

squid3 -f ${SPDYSquidConfig} -k kill
sleep 2

squid3 -f ${SPDYSquidConfig}
squid3 -f ${SPDYSquidConfig} -k reconfigure

squidCacheLog=/var/log/squid/cache.log
squid3CacheLog=/var/log/squid3/cache.log

if [[ -f ${squidCacheLog} ]];then
    cat ${squidCacheLog}
fi

if [[ -f ${squid3CacheLog} ]];then
    cat ${squid3CacheLog}
fi

isSquidRunning