#!/bin/bash

source /opt/.global-utils.sh


if [[ -z $freeServerName ]]; then
    echoS "freeServerName is empty. Stop renewing Let's Encrypt Cert." "stderr"
    exit 1
fi


if [[ ! -s $letsEncryptCertPath ]]; then
    echoS "[Let's Encrypt] $letsEncryptCertPath is not a file" "stderr"
    exit 1
fi

if [[ ! -s $letsEncryptKeyPath ]]; then
    echoS "[Let's Encrypt] $letsEncryptKeyPath is not a file" "stderr"
    exit 1
fi


echoS "Start to Renew Let's Encrypt Cert."

prepareLetEncryptEnv

#certLog=$(eval "$letsencryptCertBotPath renew --agree-tos -n")
#certLog=$(letsencrypt renew --agree-tos -n)
certLog=$(certbot renew --agree-tos -n)
echo $certLog
certDone=$(echo $certLog | grep "The following certs have been renewed")

if [[ ! -z $certDone ]]
then
        killall nghttpx
        ${binDir}/restart-spdy-nghttpx-squid.sh
fi

afterLetEncryptEnv


exit 0