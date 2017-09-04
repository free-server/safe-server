#!/bin/bash

source /opt/.global-utils.sh

port=80

restartPortService() {
    port=$1
    runCommandIfPortClosed "$port" "${binDir}/restart-misc.sh"
}

restartPortService $port