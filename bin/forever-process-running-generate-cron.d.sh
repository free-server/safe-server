#!/bin/bash

source /opt/.global-utils.sh

## file to write to cron.d
file="/etc/cron.d/free-server-forever-process-running-PROCESS_NAME"

## process checking pattern, for gawk
processPatt="lib\/PROCESS_NAME"

## process restart daily command
restartCommand="service PROCESS_NAME restart"

## write watching process every 5 minutes
echo "*/2 * * * * root ${binDir}/forever-process-running.sh \"${processPatt}\" \"${restartCommand}\"" > ${file}

## restart process every day at 5am
echo "5 5 * * * root ${restartCommand}" >> ${file}

echo "Done, cat ${file}"
cat ${file}

## restart crond
service cron restart
echo "Crontab restart, new PID: $(pgrep cron)"