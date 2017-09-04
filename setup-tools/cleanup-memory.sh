#!/usr/bin/env bash

source /opt/.global-utils.sh


echoS "Cleanup Memory"

killall nodejs

pkill -ef ^ocserv
pkill ss-server

killProcessesByPattern server.py
killProcessesByPattern SimpleHTTPServer

pkill ^nghttpx

killall squid3
killall squid

squid3 -z
squid3 -f ${SPDYSquidConfig} -k kill

exit 0