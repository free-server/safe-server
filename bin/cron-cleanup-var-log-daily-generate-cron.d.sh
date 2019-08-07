#!/bin/bash

source /opt/.global-utils.sh

fileSize="+100M"
## file to write to cron.d
file="/etc/cron.d/free-server-cron-cleanup-var-log-daily"
fileDaily="/etc/cron.daily/free-server-cron-cleanup-var-log-daily"

## restart daily
shellCommand="find /var/log -size ${fileSize} | sort -rh | xargs rm"

## restart process every day at 2pm GMT0
echo "18 17 * * * root ${shellCommand}" > ${file}

echo '#!/bin/sh' > ${fileDaily}
echo "${shellCommand}" >> ${fileDaily}
chmod a+x ${fileDaily}

echo "Done, cat ${file}"
cat ${file}

echo "Done, cat ${fileDaily}"
cat ${fileDaily}

## restart crond
service cron restart
echo "Crontab restart, new PID: $(pgrep cron)"
