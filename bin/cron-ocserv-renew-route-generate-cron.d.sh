#!/bin/bash

source /opt/.global-utils.sh

## file to write to cron.d
file="/etc/cron.d/free-server-renew-route-ocserv"

## process restart daily command
restartCommand="/bin/bash ${binDir}/renew-route-ocserv.sh"

## renew route every day
echo "30 21 * * * root ${restartCommand}" >> ${file}

echo "Done, cat ${file}"
cat ${file}

## restart crond
service cron restart
echo "Crontab restart, new PID: $(pgrep cron)"