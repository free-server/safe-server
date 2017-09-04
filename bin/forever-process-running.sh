#!/bin/bash

processName=$1
commandToRun=$2

if [[ -z $processName || -z $commandToRun ]];then
        echo "Usage: $0 processName commandToRun. Exit"
        exit
fi
getRunningProcess=$(ps aux | gawk "/$1/ {print}" | grep -v gawk | grep -v "$0")
if [ -z "$getRunningProcess" ]; then
        echo -e "Process $1 is not existed. Execute command \`$commandToRun\` now \n\n" | wall
        eval "$commandToRun"
else
 echo -e "$getRunningProcess\n\n"
 echo "Skip command $commandToRun"
fi