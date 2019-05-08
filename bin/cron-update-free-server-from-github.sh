#!/bin/bash

source /opt/.global-utils.sh
env > ${currentLoggedInUserGlobalEnv}
# Update free-server self every month
echo "30 3 1  * * root ${binDir}/renew-update-free-server.sh" > /etc/cron.d/renew_update_free_server
