#!/bin/bash

source /opt/.global-utils.sh

## file to write to cron.d
file="/etc/cron.d/free-server-forever-process-running-misc"

## write watching process every 5 minutes
echo "*/2 * * * * root ${binDir}/restart-dead-misc.sh" > ${file}

## process restart daily command
restartCommand="/bin/bash ${binDir}/restart-misc.sh"

## restart process every day at 5am
echo "5 5 * * * root ${restartCommand}" >> ${file}
echo "@reboot root ${restartCommand}" >> ${file}


echo "Done, cat ${file}"
cat ${file}

## restart crond
service cron restart
echo "Crontab restart, new PID: $(pgrep cron)"