#!/bin/bash

source /opt/.global-utils.sh

port=${miscWebsitePortHttps}

restartPortService() {
    port=$1
    runCommandIfPortClosed "$port" "${binDir}/restart-misc.sh"
}

restartPortService $port