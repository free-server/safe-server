#!/usr/bin/env bash

source /opt/.global-utils.sh

main() {
    installDeps
}

installDeps() {
    # auto remove useless packages that may cause BBR/free-server installation failure
#   apt-get install -y trickle 2>&1 >> ${loggerStdoutFile}
#    echo "Skip trickle since new SSR support speed limit"
    apt-get -y install libexpat1-dev libpython-dev libpython2.7-dev python-dev python3 2>&1 >> ${loggerStdoutFile}
}

sendSSHConnectionSignal

main "$@"

exit 0




