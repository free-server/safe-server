#!/bin/bash

source /opt/.global-utils.sh

restartPortService() {
    port=$1
    runCommandIfPortClosed "$port" "ocserv -c ${ocservConfig}.${port};  echo \"Start Cisco AnyConnect VPN (ocserv) at $port\""
}

for (( port=$ocservPortMin; port<=$ocservPortMax; port++ ));do
    restartPortService $port
done

#port=443
#restartPortService $port



