#!/usr/bin/env bash

source /opt/.global-utils.sh

isLetsEncryptCertBackuped=0

main() {
    installLetsencrypt
#    linkBinUtilAsShortcut
    prepareLetEncryptEnv

    getCert
    checkIfCertFetchSuccess

    afterLetEncryptEnv
    enableAutoRenew

}

backupLetsEncryptCert(){
    if [[ -d ${letsEncryptCertFolder}  ]];then
        mkdir -p ${letsEncryptCertFolderBackup}
        mv ${letsEncryptCertFolder}/* ${letsEncryptCertFolderBackup}/
        isLetsEncryptCertBackuped=1
    fi
}

restoreLetsEncryptCert(){
    if [[ "${isLetsEncryptCertBackuped}" == "1"  ]];then
        mkdir -p ${letsEncryptCertFolder}
        mv ${letsEncryptCertFolderBackup}/* ${letsEncryptCertFolder}/
    fi
}

installLetsencrypt() {
#    echoS "Installing git"
#    catchError=$(apt-get install -y git 2>&1 >> ${loggerStdoutFile})
#    exitOnError "${catchError}"
##
#    git config --global user.name "Free Server"
#    git config --global user.email "${freeServerUserEmail}"
#    cd ${letsencryptInstallationFolder}

    # clean log
    rm -rf ${letsEncryptLogFile}

#    echoS "Cleanup Let's Encrypt on /etc/letsencrypt"
#    rm -rf /etc/letsencrypt

#    git clone https://github.com/letsencrypt/letsencrypt ./ 2>&1 >> ${loggerStdoutFile}
#    ./letsencrypt-auto --help --agree-tos 2>&1 >> ${loggerStdoutFile}
  apt-get install -y software-properties-common 2>&1 >> ${loggerStdoutFile}
  add-apt-repository -y ppa:certbot/certbot 2>&1 >> ${loggerStdoutFile}
  apt-get -y update 2>&1 >> ${loggerStdoutFile}
  #apt-get install -y letsencrypt  2>&1 >> ${loggerStdoutFile}
  apt-get install -y certbot 2>&1 >> ${loggerStdoutFile}




}

getCert() {
#    eval "$letsencryptCertBotPath certonly --standalone --non-interactive --agree-tos -n --email=${freeServerUserEmail} -d ${freeServerName}"
    certbot certonly --standalone --non-interactive --agree-tos -n --email=${freeServerUserEmail} -d ${freeServerName}
    certbot renew --dry-run --agree-tos 2>&1 >> ${loggerStdoutFile}

    isLetsEncryptHasError=$(cat ${letsEncryptLogFile} | grep "Error creating new cert")

    if [[ ! -z ${isLetsEncryptHasError} ]]; then
        echoErr "[ERROR] Let's Encrypt throw errors."
        exitOnError "[ERROR] Run cat ${letsEncryptLogFile} for more"
    fi
}

enableAutoRenew() {
    echo "6 50 *  * 1 root ${binDir}/renew-letsencrypt.sh" > /etc/cron.d/renew_letsencrypt
    # run for first time
}

checkIfCertFetchSuccess(){

  if [[ ! -f "${letsEncryptCertPath}" ]];then
    exitOnError "[ERROR] Let's Encrypt certs not found in ${letsEncryptCertPath}. Aborted."
  fi
}

#linkBinUtilAsShortcut() {
#
#    ln -s ${binDir}/renew-letsencrypt.sh ${binDir}/renew-letsencrypt.sh
#
#}

main "$@"


exit 0

