#!/bin/bash

SSH_SIGNAL_PROCESS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source /opt/.global-utils.sh

while [[ 1 = 1 ]];do
    echo "[$0] SSH is still connected $(date)"
    sleep 30
done