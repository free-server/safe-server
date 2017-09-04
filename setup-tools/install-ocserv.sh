#!/usr/bin/env bash

source /opt/.global-utils.sh

main() {
    installOcserv 2>&1  > /dev/null
    updateOcservConf
#    linkBinUtilAsShortcut


}

installOcserv() {
    cd ${gitRepoPath} 2>&1  > /dev/null

    wget ${ocservDownloadLink} 2>&1  > /dev/null
    tar -xf ${ocservTarGzName} 2>&1  > /dev/null
    cd ${ocservFolderName} 2>&1  > /dev/null

    apt-get install -y build-essential pkg-config libgnutls28-dev libwrap0-dev libpam0g-dev libseccomp-dev libreadline-dev libnl-route-3-dev 2>&1  >> /dev/null
    ./configure 2>&1  >> /dev/null && make  2>&1  >> /dev/null && make install  2>&1  >> /dev/null
}

main "$@"





