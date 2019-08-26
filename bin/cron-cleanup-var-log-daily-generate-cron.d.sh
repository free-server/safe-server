#!/bin/bash

source /opt/.global-utils.sh

fileSize="+100M"
## file to write to cron.d
file="/etc/cron.d/free-server-cron-cleanup-var-log-daily"


#file2AzureLog="/etc/cron.d/free-server-cron-cleanup-var-log-daily-2-azure"
fileDaily="/etc/cron.daily/free-server-cron-cleanup-var-log-daily"

## clear big log files
shellCommand="find /var/log -size ${fileSize} | sort -rh | xargs rm"

## clear Azure Logs which will consume all inode
#shellCommand2AzureLog="rm -rf /var/lib/waagent/history/"

## restart process every day at 2pm GMT0
echo "18 17 * * * root ${shellCommand}" > ${file}

#echo "19 17 * * * root ${shellCommand2AzureLog}" > ${file2AzureLog}

echo '#!/bin/sh' > ${fileDaily}
echo "${shellCommand}" >> ${fileDaily}
chmod a+x ${fileDaily}

echo "Done, cat ${file}"
cat ${file}

#echo "Done, cat ${file2AzureLog}"
#cat ${file2AzureLog}

echo "Done, cat ${fileDaily}"
cat ${fileDaily}

## restart crond
service cron restart
echo "Crontab restart, new PID: $(pgrep cron)"
