#!/bin/bash

source /opt/.global-utils.sh
echo "18 21 *  * 1 root ${binDir}/renew-letsencrypt.sh" > /etc/cron.d/renew_letsencrypt