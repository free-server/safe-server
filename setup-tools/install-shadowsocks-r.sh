#!/usr/bin/env bash

source /opt/.global-utils.sh

# disable previous ss-server
oldSsServer=/usr/bin/ss-server
if [[ -f ${oldSsServer} ]];then
    mv ${oldSsServer} ${oldSsServer}.bak
    pkill ss-server
fi

cd ${gitRepoPath}


git clone -b manyuser ${shadowsocksRRepo}

if [[ ! -z ${shadowsocksRRepoRevision} ]];then
    cd ${shadowsocksRFolder}
    git checkout ${shadowsocksRRepoRevision}
    cd ..
fi

# prepare all Shadowsocks Utils

sendSSHConnectionSignal

optimizeLinuxForShadowsocksR

exit 0

## create first shadowsocks account
#tmpPort=40000
#tmpPwd=`randomString 8`
#${freeServerRoot}/createuser-shadowsocks ${tmpPort} ${tmpPwd}  > /dev/null
#echoS "First Shadowsocks account placeholder created, with Port ${tmpPort} and Password ${tmpPwd}. \n \
#You should not remove the placeholder since it's used by script ${freeServerRoot}/createuser-shadowsocks"
