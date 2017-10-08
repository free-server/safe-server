#!/bin/bash

source /opt/.global-utils.sh

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "Usage: $0"

  exit 0
fi

echoS "Restart SPDY Squid3"

killall squid3 > /dev/null 2>&1
killall squid > /dev/null 2>&1

squid3 -k  kill > /dev/null 2>&1

squid3 -z > /dev/null 2>&1
squid3 -z -f ${SPDYSquidConfig} > /dev/null 2>&1

squid3 -f ${SPDYSquidConfig} -k kill > /dev/null 2>&1
sleep 2

squid3 -f ${SPDYSquidConfig} > /dev/null 2>&1
squid3 -f ${SPDYSquidConfig} -k reconfigure > /dev/null 2>&1

isSquidRunning