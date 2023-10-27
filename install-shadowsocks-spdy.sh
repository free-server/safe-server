#!/bin/bash

clear

if [[ $UID -ne 0 ]]; then
    echo "$0 must be run as root"
    exit 1
fi

export bashUrl=https://raw.githubusercontent.com/free-server/safe-server/master/
export self="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/$0"

export userCountPerServer=$1

# get global utils
globalUtilStoreDir=/opt
mkdir -p ${globalUtilStoreDir}
chmod 755 ${globalUtilStoreDir}
cd ${globalUtilStoreDir}
# prepare global functions
rm -f .global-utils.sh
wget --no-cache ${bashUrl}/utils/.global-utils.sh
source .global-utils.sh

acceptAllPortsForIpTableAndUfw

enforceInstallOnUbuntu
setupFreeServerUpdating

# stop accepting client locale setting for Ubuntu
replaceStringInFile "/etc/ssh/sshd_config" AcceptEnv "\#AcceptEnv"
service sshd restart

echoS "apt-get update and install required tools"
## Fix dpkg issue a
dpkg --configure -a
apt autoremove -y

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo LC_CTYPE=\"en_US.UTF-8\" > /etc/default/locale
echo LC_ALL=\"en_US.UTF-8\" >> /etc/default/locale
echo LANG=\"en_US.UTF-8\" >> /etc/default/locale

apt-get install language-pack-en-base -y
locale-gen en_US en_US.UTF-8
dpkg-reconfigure --frontend=noninteractive locales


# fix hostname -f
hostName=$(hostname)
hostNameF=$(hostname -f)
if [[ -z $hostNameF && ! -z $hostName ]]; then

    echo "127.0.1.1 ${hostName}" >> /etc/hosts
    echo "127.0.1.1 ${hostName}.local" >> /etc/hosts

fi

warnNoEnterReturnKey
apt-get update -y > /dev/null

catchError=$(apt-get install -y gawk 2>&1 > /dev/null)
exitOnError "${catchError}"

catchError=$(apt-get install -y curl 2>&1 > /dev/null)
exitOnError "${catchError}"

catchError=$(apt-get install -y git 2>&1 > /dev/null)
exitOnError "${catchError}"

echoS "Migrate obsolete installation"
cd ${globalUtilStoreDir}
rm -f migrate.sh

catchError=$(downloadFileToFolder ${baseUrlSetupTools}/migrate.sh ${globalUtilStoreDir}/ 2>&1  > /dev/null)
exitOnError "${catchError}"

chmod 755 ./migrate.sh
./migrate.sh

echoS "Init Env"
warnNoEnterReturnKey

if [[ -d ${freeServerRoot} ]]; then
    echoS "Old free-server installation detected. Script is going to perform Save Upgrading in 5 seconds.\
     Press Ctrl+C to cancel"

    echoS "If you want to perform fresh installation, just remove or rename ${freeServerRoot}"
    sleep 5

    echoS "Removing Old free-server installation"

    # restore backed up config files
    if [[ -d ${configDirBackup} ]]; then
        echoS "Old backed up config files found in ${configDirBackup} ${configDirBackupDate}. \
        This is not correct. You should move it to other place or just delete it before proceed. Exit"
        cleanUpFreeServerUpdating
        exit 0
    fi

    # clear up previous stdout/stderr file
    rm -f ${loggerStdoutFile}
    rm -f ${loggerStderrFile}

    rm -f ${configDir}/haproxy.conf
    rm -f ${configDir}/haproxy-user.conf
    rm -f ${configDir}/squid.conf
    rm -f ${configDir}/ocserv.conf
    rm -f ${configDir}/ocserv.xml

    # move current config files to a save place if has

    mv ${configDir} ${configDirBackup}
    # copy a another backup
    cp -nr ${configDirBackup} ${configDirBackupDate}

    rm -rf ${freeServerRoot}

fi


echoS "Create Folder scaffold"

wget --no-cache -qO- ${baseUrlSetupTools}/init-folders.sh | /bin/bash

echoS "Restore Config"


# restore backed up config files
if [ -d ${configDirBackup} ]; then
    rm -rf ${configDir}
    mv ${configDirBackup} ${configDir}
    # since we restored AnyConnect, it's necessary to have this incremental configuration
    if [[ ! -z ${isToInstallOcservCiscoAnyConnect} && ! -f ${ocservPasswd} ]];then
        touch ${ocservPasswd}
    fi
    source .global-utils.sh
fi


echoS "Get Global Settings"

if [[ -z $freeServerName ]]; then
    setServerName
    source .global-utils.sh
else
    echoS "[INFO] $freeServerName found in ${freeServerGlobalEnv}. Skip setting name."
fi

if [[ -z $freeServerUserEmail ]]; then
    setEmail
    source .global-utils.sh
else
    echoS "[INFO] $freeServerUserEmail found in ${freeServerGlobalEnv}. Skip setting email."
fi

setUserCountPerServer ${userCountPerServer}
source .global-utils.sh


# clear all old crontab
rm -f /etc/cron.d/forever-process-running-*
rm -f /etc/cron.d/renew_letsencrypt
rm -f /etc/cron.d/free-server*
service cron restart 2>&1 > /dev/null


echoS "Getting and processing utility package"
warnNoEnterReturnKey

#downloadFileToFolder ${bashUrl}/setup-tools/download-files.sh ${freeServerRootTmp}
#chmod 755 ${freeServerRootTmp}/download-files.sh
#${freeServerRootTmp}/download-files.sh || exit 1

echoS "Git Cloning project"
cd ${gitRepoPath}
rm -rf ${gitRepoFreeServerPath}
git clone ${freeServerRepo} ${freeServerInstallationFolderName}



find ./ -name "*.sh" | xargs chmod +x
cd free-server
git add .
git commit -m "chmod"


#echoS "Installing NodeJS and NPM"
#warnNoEnterReturnKey
#${setupToolsDir}/install-node.sh || exit 1

echoS "Copy Config samples"
${setupToolsDir}/copy-conf.sh || exitOnError "[ERROR] main step installation failed"

echoS "Installing Dependencies"
${setupToolsDir}/install-dependencies.sh || exitOnError "[ERROR] main step installation failed"

echoS "Installing Let's Encrypt"
${setupToolsDir}/install-letsencrypt.sh || exitOnError "[ERROR] main step installation failed"

echoS "Installing and initialing Shadowsocks-R"
warnNoEnterReturnKey

${setupToolsDir}/install-shadowsocks-r.sh || exitOnError "[ERROR] main step installation failed"

echoS "Installing HTTP/2 Proxy"
warnNoEnterReturnKey

#${setupToolsDir}/install-spdy.sh
${setupToolsDir}/install-spdy-nghttpx-squid.sh || exitOnError "[ERROR] main step installation failed"

${setupToolsDir}/update-tutorials.sh || exitOnError "[ERROR] main step installation failed"

#echoS "Installing IPSec/IKEv2 VPN (for IOS)"
#${setupToolsDir}/install-ipsec-ikev2.sh || exit 1

if [[ ! -z ${isToInstallOcservCiscoAnyConnect} ]];then
    echoS "Installing Cisco AnyConnect (Open Connect Ocserv)"
    ${setupToolsDir}/install-ocserv.sh || exitOnError "[ERROR] main step installation failed"
fi

#echoS "Installing and Initiating Free Server Cluster for multiple IPs/Domains/Servers with same Login Credentials support"
#
#${setupToolsDir}/install-cluster.sh





echoS "Restart and Init Everything in need"

cleanUpFreeServerUpdating

${setupToolsDir}/init.sh || exitOnError "[ERROR] main step installation failed"

echoS "All done. Create user example: \n\n\
\
Shadowsocks-R+HTTP/2: ${binDir}/createuser.sh User Pass ShadowsocksPort SPDYPort EmailAddress\n\n\
\
Shadowsocks-R Only: ${binDir}/createuser-shadowsocks-r.sh Port Pass \n\n\
\
HTTP/2 Only: ${binDir}/createuser-spdy-nghttpx-squid.sh User Pass Port \n\n\
\
"

echoS "\x1b[46m Next step: \x1b[0m\n\n\
1. Create a user: ${binDir}/createuser.sh USERNAME PASSWORD ShadowsocksRPort HTTP2Port EmailAddress \n\n\
2. Config Chrome or other client. Tutorial is here: ${freeServerProjectUrl}#how-to-setup-clients \n\n\
"

#echoS "Note that, the IpSec PSK(Secret) is located: \x1b[46m ${ipsecSecFile} \x1b[0m. You may want to reedit the PSK field."
# remove self

echoS "[MORE] BBR: I highly recommend you to install Google TCP BBR: https://doub.io/wlzy-16/ manually"

source /opt/.global-utils.sh
mailNotify "Updated - Safe server update finished at $(getCurrentDateTime)" "Create user: ${binDir}/createuser.sh USERNAME PASSWORD ShadowsocksRPort HTTP2Port EmailAddress \n\n\ Chrome Setup Tutorial: ${httpsFreeServerUrlHttp2Tutorial}"

rm -f "$self"

isLetsEncryptInstalled
isSquidRunning
isSSRRunning

exit 0



