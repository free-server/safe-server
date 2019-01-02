#!/bin/bash


export SHELL=/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

if [[ $UID -ne 0 ]]; then
    echo "$0 must be run as root"
    exit 1
fi

getCurrentDate(){
  date +"%m_%d_%Y"
}
export -f getCurrentDate

getCurrentDateTime(){
  date +"%m_%d_%Y__%H_%M_%S"
}
export -f getCurrentDateTime

getCurrentDateTimeHour(){
  date +"%m_%d_%Y__%H"
}
export -f getCurrentDateTimeHour

export currentDate=$(getCurrentDate)
export currentDateTime=$(getCurrentDateTime)
export currentDateTimeHour=$(getCurrentDateTimeHour)

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export globalUtilFile=$0

export bashrc=~/.bashrc

if [[ -f  ${bashrc} ]];then
    source ${bashrc}
fi

export freeServerCodeRepoName=safe-server
export freeServerGithubUserName=free-server
export freeServerProjectUrl=https://github.com/${freeServerGithubUserName}/${freeServerCodeRepoName}
export freeServerRepo=${freeServerProjectUrl}.git
export baseUrl=https://raw.githubusercontent.com/free-server/safe-server/master/

export freeServerInstallationFolderName=free-server
# the top install folder
export freeServerRoot=/opt/${freeServerInstallationFolderName}/

export gitRepoPath=${freeServerRoot}/git-repo
export gitRepoFreeServerPath=${gitRepoPath}/free-server
export gitRepoShadowsocksRPath=${gitRepoPath}/shadowsocksr


# utility folder
export binDir=${gitRepoFreeServerPath}/bin
export setupToolsDir=${gitRepoFreeServerPath}/setup-tools
export miscDir=${gitRepoFreeServerPath}/misc
export configSampleDir=${gitRepoFreeServerPath}/config-sample

# for configration samples
export configDir=${freeServerRoot}/config
export configDirBackup=/opt/free-server-config-bak
export configDirBackupDate=/opt/free-server-config-bak-$currentDate

export freeServerGlobalEnv=${configDir}/envrc

if [[ -f ${freeServerGlobalEnv} ]]; then
    source ${freeServerGlobalEnv}
fi

export SPDYConfig="${configDir}/SPDY.conf"
export shadowsocksRConfig="${configDir}/SSR.conf"


#####################
## Start of main configuration after sourcing Global Env (bashrc + freeserver envrc)
#####################

if [[ -z ${miscWebsitePortHttps} ]]; then
    export miscWebsitePortHttps=443
fi

if [[ -z ${miscWebsitePortHttp} ]]; then
    export miscWebsitePortHttp=80
fi

httpsPortSuffix=""
if [[ "${miscWebsitePortHttps}" != "443" ]]; then
    httpsPortSuffix=":${miscWebsitePortHttps}"
fi

export httpsFreeServerUrl="https://${freeServerName}${httpsPortSuffix}"
export httpsFreeServerUrlHttp2Tutorial=${httpsFreeServerUrl}/#http2

# let's encrypt
export letsEncryptCertFolder=/etc/letsencrypt/live/$freeServerName
export letsEncryptCertFolderBackup=/root/letsEncryptCertBackup/
export letsEncryptCertPath=${letsEncryptCertFolder}/fullchain.pem
export letsEncryptKeyPath=${letsEncryptCertFolder}/privkey.pem
export letsencryptInstallationFolder=${freeServerRoot}/letsencrypt
export letsencryptAutoPath=${letsencryptInstallationFolder}/letsencrypt-auto
export letsencryptCertBotPath=${letsencryptInstallationFolder}/certbot-auto

export letsEncryptLogFile=/var/log/letsencrypt/letsencrypt.log


# temporary folder for installation
export freeServerRootTmp=${freeServerRoot}/tmp

export baseUrlUtils=${baseUrl}/utils
export baseUrlBin=${baseUrl}/bin
export baseUrlSetupTools=${baseUrl}/setup-tools
export baseUrlConfigSample=${baseUrl}/config-sample
export baseUrlMisc=${baseUrl}/misc

export userCountPerServerDefault=5

if [[ -f ${SPDYConfig} ]];then
    export userCountPerServer=$(wc -l < ${SPDYConfig})
fi

if [[ -z ${userCountPerServer} || "${userCountPerServer}" == "0" ]];then
    export userCountPerServer=${userCountPerServerDefault}
fi

if [[ -z ${freeServerUserCountPerServer}  || "${freeServerUserCountPerServer}" == "0" ]];then
    export freeServerUserCountPerServer=${userCountPerServer}
fi
# https://nghttp2.org/documentation/nghttpx.1.html
# band width (KB)
export bandwidthMax=3000
export bandwidthPerUserFactor=7
export bandwidthPerUser=$((bandwidthMax*bandwidthPerUserFactor/freeServerUserCountPerServer))

#export oriConfigShadowsocksDir="/etc/shadowsocks-libev/"
#export oriConfigShadowsocks="${oriConfigShadowsocksDir}/config.json"

export shadowsocksREncrypt="aes-256-cfb"
export shadowsocksRObfuscate="tls1.2_ticket_auth"
export shadowsocksRProtocol="auth_sha1_v4"
export shadowsocksRObfuscateParam="s3.amazonaws.com"

# KB/S
export shadowsocksRSpeedPerCon=$((bandwidthPerUser/2))
export shadowsocksRSpeedPerUser=${bandwidthPerUser}
export shadowsocksRMaxDeviceCountPerPort=3
export shadowsocksRProtocolParam=${shadowsocksRMaxDeviceCountPerPort}

export shadowsocksRRepo=https://github.com/shadowsocksr-backup/shadowsocksr.git
# https://github.com/Ssrbackup/shadowsocksr/commit/82f8fef28aa300ea3ad3e09a4742da5108b98e68
#export shadowsocksRRepoRevision=db6629a1307ed38eb507bd926ad1503e90bc4eb1
export shadowsocksRFolder="${gitRepoShadowsocksRPath}/shadowsocks"
export shadowsocksRWorkerCount=$((freeServerUserCountPerServer/3))
if [ ${shadowsocksRWorkerCount} -lt 2 ];then
    shadowsocksRWorkerCount=2
fi
export shadowsocksRConfigJson="${configDir}/SSR.json"


export nghttpxWorkerCount=$((freeServerUserCountPerServer/3))
if [ ${nghttpxWorkerCount} -lt 2 ];then
    nghttpxWorkerCount=2
fi
export nghttpxUploadLimit="$((bandwidthPerUser*8*1024))"
export nghttpxDownloadLimit="$((bandwidthPerUser*8*1024))"

# support 0-RTT
export SPDYNgHttp2Version=1.35.1
export SPDYNgHttp2DownloadLink="https://github.com/nghttp2/nghttp2/releases/download/v${SPDYNgHttp2Version}/nghttp2-${SPDYNgHttp2Version}.tar.gz"
export SPDYNgHttp2FolderName="nghttp2-${SPDYNgHttp2Version}"
export SPDYNgHttp2TarGzName="${SPDYNgHttp2FolderName}.tar.gz"

export SPDYSpdyLayDownloadLink="https://github.com/tatsuhiro-t/spdylay/releases/download/v1.4.0/spdylay-1.4.0.tar.gz"
export SPDYSpdyLayFolderName="spdylay-1.4.0"
export SPDYSpdyLayTarGzName="${SPDYSpdyLayFolderName}.tar.gz"

export spdyInstalledPath=/usr/local/include/spdylay

export SPDYSquidConfig="${configDir}/squid.conf"
export SPDYSquidCacheDir="/var/spool/squid"
export SPDYSquidPassWdFile="${configDir}/squid-auth-passwd"

# make SPDYSquidAuthSubProcessAmount bigger, make squid basic auth faster, but may be more unstable indeed
export SPDYSquidAuthSubProcessAmount=4

export SPDYForwardBackendSquidHost="127.0.0.1"
export SPDYForwardBackendSquidPort=3128
export SPDYFrontendListenHost="0.0.0.0"

# make SPDYNgHttpXCPUWorkerAmount bigger, make nghttpx faster, but may be unstable if your VPS is not high-end enough
export SPDYNgHttpXCPUWorkerAmount=2

export SPDYNgHttpXConcurrentStreamAmount=50

export ipsecSecFile=${configDir}/ipsec.secrets
export ipsecSecFileInConfigDirBackup=${configDirBackup}/ipsec.secrets
export ipsecSecFileOriginal=/usr/local/etc/ipsec.secrets
export ipsecSecFileOriginalDir=/usr/local/etc/
export ipsecSecFileBak=/usr/local/etc/ipsec.secrets.bak.free-server
#export ipsecSecFileBakQuericy=/usr/local/etc/ipsec.secrets.bak.quericy
export ipsecSecPskSecretDefault=freeserver
export ipsecStrongManVersion=strongswan-5.3.3
export ipsecStrongManVersionTarGz=${ipsecStrongManVersion}.tar.gz
## ipsecStrongManOldVersion should be added if you want to update the ${ipsecStrongManVersion}, so that the script can clean the old files
export ipsecStrongManOldVersion=strongswan-5.2.1
export ipsecStrongManOldVersionTarGz=${ipsecStrongManOldVersion}.tar.gz

#export isToInstallOcservCiscoAnyConnect
# for latest version: ftp://ftp.infradead.org/pub/ocserv/
export ocservDownloadLink="ftp://ftp.infradead.org/pub/ocserv/ocserv-0.11.8.tar.xz"
export ocservFolderName="ocserv-0.11.8"
export ocservTarGzName="${ocservFolderName}.tar.xz"
export ocservPasswd=${configDir}/ocserv.passwd
export ocservConfig="${configDir}/ocserv.conf"

export ocservPortMin=3000
ocservPortMaxDefault=3001
ocservPortMax=$ocservPortMaxDefault
if [[ -f ${ocservPasswd} && -f ${ocservConfig} ]];then
    ocservPortMax=$(wc -l < ${ocservConfig})
    ocservPortMax=$((ocservPortMax/10))
    if [[ ${ocservPortMax} -lt ${ocservPortMaxDefault} ]];then
        ocservPortMax=$ocservPortMaxDefault
    fi
fi
export ocservPortMax


export clusterDefFilePath="${configDir}/cluster-def.txt"
export clusterDeploySSHMutualAuthAccept="${freeServerRoot}/cluster-deploy-ssh-mutual-auth-accept"

export loggerStdoutFolder=${freeServerRoot}/log
export loggerStdoutFile=${loggerStdoutFolder}/stdout.log
export loggerStderrFile=${loggerStdoutFolder}/stderr.log
export loggerRuntimeInfoFile=${loggerStdoutFolder}/runtime_info.log
export loggerRuntimeErrFile=${loggerStdoutFolder}/runtime_error.log

export updatingFreeServerFilePath=/tmp/free-server-updating-${currentDateTimeHour}
export isFreeServerUpdating=$([[ -f ${updatingFreeServerFilePath} ]] && echo 1)

enforceInstallOnUbuntu(){
	isUbuntu=`cat /etc/issue | grep "Ubuntu"`

	if [[ -z ${isUbuntu} ]]; then
	  echoS "You could only run the script in Ubuntu"
	  exit 1
	fi

}
export -f enforceInstallOnUbuntu

enforceInstallOnUbuntu

if [[ ! -z "$(which git)" ]];then
    git config --global core.editor "vi"
fi

isUbuntu14(){
	isUbuntu=`cat /etc/issue | grep "Ubuntu 14."`

	if [[ ! -z ${isUbuntu} ]]; then
	  echo "YES"
	fi

}
export -f isUbuntu14

enforceInstallOnUbuntu

warnNoEnterReturnKey() {
  echoS "\x1b[31m Do NOT press any Enter/Return key while script is compiling / downloading \x1b[0m if haven't been asked. Or, it may fail." "stderr"
}

cleanupMemory(){
    ${setupToolsDir}/cleanup-memory.sh
}
export -f cleanupMemory

randomString()
{
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}
export -f randomString

echoS(){
  echo "***********++++++++++++++++++++++++++++++++++++++++++++++++++***********"
  echo "##"
  if [[ "$2" == "stderr" ]]; then
    >&2 echo -e "## \x1b[31m $1 \x1b[0m"
  else
    echo -e "## \x1b[34m $1 \x1b[0m"
  fi
  echo "##"

  echo "***********++++++++++++++++++++++++++++++++++++++++++++++++++***********"

}
export -f echoS

echoErr(){
  >&2 echo -e "\x1b[31m$@\x1b[0m"
}
export -f echoErr

echoSExit(){
  echoS "$1"
  sleep 1
  exit 0
}
export -f echoSExit

exitOnError(){
  if [[ ! -z $1 ]]; then
    echoS "Error message detected, content is below"
    echo "$1"
    if [[ -f ${loggerStderrFile} ]]; then

        echo "Redirect error message to ${loggerStderrFile}:"
        echo "$1" >> ${loggerStderrFile}
        sleep 1
        echo ">>>>>>>>>>>>>>>>>>"
        echo ">>>>>>>>>>>>>>>>>>"
        echo "Cat ${loggerStderrFile}:"
        cat ${loggerStderrFile}
        echo "<<<<<<<<<<<<<<<<<<"
        echo "<<<<<<<<<<<<<<<<<<"

    else
        echo "${loggerStderrFile} is not existed. Skipping saving Error Log."
    fi

    sleep 2

    echoS "[Solution] You could retry this script again. It may solve the problem. If it still fails, you could report issue to Paul on github."
    cleanUpFreeServerUpdating
    exit 1
  fi
}
export -f exitOnError


exitOnPreviousProcessQuitNonZero(){
      previousExit=$?

      if [[ ${previousExit} != 0 ]];then

        echo "Redirect error message to ${loggerStderrFile}:"
        echo "$1" >> ${loggerStderrFile}
        sleep 1
        echo ">>>>>>>>>>>>>>>>>>"
        echo ">>>>>>>>>>>>>>>>>>"
        echo "Cat ${loggerStderrFile}:"
        cat ${loggerStderrFile}
        echo "<<<<<<<<<<<<<<<<<<"
        echo "<<<<<<<<<<<<<<<<<<"
        exit ${previousExit}

      fi

}
export -f exitOnPreviousProcessQuitNonZero

checkPortClosed(){
    sleep 1
    port=$1
    nc -z localhost $port
}
export -f checkPortClosed

waitUntilPortOpen() {
    port=$1
    maxWait=$2
    currentSecond=0
    checkPortClosed ${port}
    isPortClosed=$?

    while (( $currentSecond < $maxWait ))  && [[ $isPortClosed == 1 ]]; do
        sleep 1

        checkPortClosed ${port}

        isPortClosed=$?

        (( currentSecond++ ))
    done

    if [[ $isPortClosed == 1 ]]; then
        echoErr "Error: Port $port is still closed on max timeout $maxWait seconds."
        return 1
    else
        return 0
    fi
}
export -f waitUntilPortOpen

runCommandIfPortClosed(){
    port=$1
    commandToRun=$2

    checkPortClosed ${port}
    isPortClosed=$?

    if [[ $isPortClosed == 0 ]]; then
        return 0
    else
        eval $commandToRun
    fi

    maxTry=2
    currentTry=0

    while (( $currentTry < $maxTry ))  && [[ $isPortClosed == 1 ]]; do

            waitUntilPortOpen ${port} 3

            isPortClosed=$?

            if [[ $isPortClosed == 0 ]]; then
                return 0
            else
                echo ""
                #eval $commandToRun
            fi

            (( currentTry++ ))

    done
}
export -f runCommandIfPortClosed


killProcessesByPattern(){
  echo -e "\nThe process(es) below would be killed"
  ps aux | gawk '/'$1'/ {print}' | cut -d" " -f 24-
  ps aux | gawk '/'$1'/ {print $2}' | xargs kill -9
  echo -e "\n\n"

}
export -f killProcessesByPattern

removeWhiteSpace(){
  echo $(echo "$1" | gawk '{gsub(/ /, "", $0); print}')
}
export -f removeWhiteSpace

#####
# get interfact IP
#####
getIp(){
  /sbin/ifconfig|grep 'inet addr'|cut -d':' -f2|awk '!/127/ {print $1}'
}
export -f getIp

#####
# download a file to folder
#
# @param String $1 is the url of file to downlaod
# @param String $2 is the folder to store
# @example downloadFileToFolder http://server1.free-server.me/some.zip ~/free-server
#####
downloadFileToFolder(){
  echo "[$FUNCNAME] Prepare to download file $1 into Folder $2"

  if [ ! -d "$2" ]; then
    echoS "[$FUNCNAME] Folder $2 is not existed. Exit" "stderr"
    exit 1
  fi
  if [ -z $1 ]; then
    echoS "[$FUNCNAME] Url must be provided. Exit" "stderr"
    exit 1
  fi
  wget --no-cache -q --directory-prefix="$2" "$1"
}
export -f downloadFileToFolder


#####
#
# @param String $1 is the file to operate
# @param RegExp String $2 is searching pattern in regexp
# @param RegExp String $3 is replacement
#####
replaceStringInFile(){

  if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
  then
    echo "$FUNCNAME FileName SearchingPattern Replacement "
    exit 0
  fi

  # all the arguments should be given
  if [[ -z $1 || -z $2 || -z $3 ]];then
    echo "[$FUNCNAME] You should provide all 3 arguments to invoke $FUNCNAME"
    exit 1
  fi

  if [[ ! -f $1 ]]; then
    echo "[$FUNCNAME] File $1 is not existed"
    exit 1
  fi

  # find and remove the line matched to the pattern

  sed -i "s#$2#$3#g" $1

}
export -f replaceStringInFile


#####
#
# @param String $1 is the file to operate
# @param RegExp String $2 is searching pattern for sed
#####
removeLineInFile(){

  if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
  then
    echo "$FUNCNAME FileName SearchingPattern"
    exit 0
  fi

  # all the arguments should be given
  if [[ -z $1 ]] || [[ -z $2 ]];then
    echo "You should provide all 2 arguments to invoke $$FUNCNAME"
    exit 1
  fi

  if [[ ! -f $1 ]]; then
    echo "File $1 is not existed"
    exit 1
  fi

  # find and remove the line matched to the pattern

  sed -i "/$2/d" $1

}
export -f removeLineInFile

# usage:   removeLineByRegPattAndInsert /etc/sysctl.conf "fs\.file-max" "fs.file-max = 51200"
removeLineByRegPattAndInsert() {
  file=$1
  regexpForSed=$2
  linkToAppend=$3
  removeLineInFile "${file}" "${regexpForSed}"
  echo "${linkToAppend}" >> "${file}"

}
export -f removeLineByRegPattAndInsert

#####
# Add date to String
#
# @param String $1 is the origin String
# @example file$(appendDateToString).bak
#####
appendDateToString(){
  echo "-$currentDate"
}
export -f appendDateToString


#####
# Get User Input
#
# @param String $1 is the prompt
# @param String $2 file if the input must be a file, non-empty if the input must not empty
# @param Number $3 Max try times

# @example input=$(getUserInput "Provide File" file 3)
#####
getUserInput(){

  promptMsg=$1
  inputValidator=$2
  maxtry=$3

  userinput=''

  if [[ -z ${promptMsg} ]]; then
    echoS '@example input=$(getUserInput "Provide File" file 3)'
    exit 0
  fi

  if [[ -z ${maxtry} ]]; then
    maxtry=3
  fi

  while [ ${maxtry} -gt 0 ]; do

    sleep 1

    read -p "$(echo -e ${maxtry} attempt\(s\) left, ${promptMsg}) \$: " userinput
    userinput=$(removeWhiteSpace "${userinput}")

    if [[ "${inputValidator}" == "file" ]]; then
      if [[ ! -f "${userinput}"  ]]; then
        echoErr "The file ${userinput} you input is empty or not a file."
        userinput=''
      else
        break
      fi
    fi

    if [[ "${inputValidator}" == "non-empty" ]]; then
      if [[  -z "${userinput}" ]]; then
        echo "\x1b[0m The input should not be empty.\x1b[0m"
      else
        break
      fi
    fi


    ((maxtry--))

    if [[ -z ${inputValidator} ]]; then
        break
    fi

  done

  echo ${userinput}

}
export -f getUserInput


#####
# Import MySQL db sql backup tar.gz to database
#
# @param String $1 is the backup folder to list
# @param String $2 is the database name
# @example importSqlTarToMySQL Folder
#####
importSqlTarToMySQL(){

  dbFolder=$1

  if [[ ! -d ${dbFolder} ]]; then
    echoS "Folder ${dbFolder} is not existed" "stderr"
    echoS "@example importSqlTarToMySQL ~/backup/"
    return 0
  fi

  echoS "Here is all the files found within folder ${dbFolder}\n"
  cd ${dbFolder}
  ls . | grep .gz

  echo -e "\n\n"

  dbTarGz=$(getUserInput "Enter a *.tar.gz to import (Copy & Paste):  " file)
  echoS "Selected tar.gz is ${dbTarGz}"

  if [[ ! -f ${dbTarGz} || -z $(echo ${dbTarGz} | grep .gz) ]]; then
    echoS "${dbTarGz} is not a valid *.tar.gz file"
    exit 0
  fi

  sleep 1

  # provide the db name to create
  dbName=$(getUserInput "the database name to import to:  " non-empty)
  echoS "dbName is ${dbName}"
  if [[  -z ${dbName} ]]; then
    exit 0
  fi

  sleep 1


  # provide the new user name
  dbNewUser=$(getUserInput "The owner user name of database ${dbName} (Non-root):  " non-empty)
  echoS "dbNewUser is ${dbNewUser}"
  if [[  -z ${dbNewUser} ]]; then
    exit 0
  fi

  sleep 1


  # provide password for the new user
  dbPass=$(getUserInput "input password for user ${dbNewUser} of Db ${dbName} (Non-root):  " non-empty)
  echoS "dbPass is ${dbPass}"
  if [[  -z ${dbPass} ]]; then
    exit 0
  fi

  sleep 1


  # create user and grant
  echoS "Create new Db ${dbName} with Db user ${dbNewUser}. \n\nProvide MySQL root password:"

  sql="CREATE DATABASE IF NOT EXISTS ${dbName} ; \
  GRANT ALL PRIVILEGES ON ${dbName}.* To '${dbNewUser}'@'localhost' IDENTIFIED BY '${dbPass}';\
  FLUSH PRIVILEGES;"
  mysql -uroot -p -e "$sql"

  echoS "Exact ${dbTarGz}."
  rm -rf ~/__to_import > /dev/null
  mkdir -p ~/__to_import  > /dev/null
  tar zxf ${dbTarGz} -C ~/__to_import
  cd ~/__to_import  > /dev/null

  sleep 1

  dbSql=$(ls . | gawk '/\.sql/ {print}')

  echoS "Importing ${dbSql} to database ${dbName}.\n\n Provide MySQL root password again:"
  mysql -uroot -p ${dbName} < ${dbSql}
  rm -rf ~/__to_import
}
export -f importSqlTarToMySQL


optimizeLinuxForShadowsocksR(){

  removeLineByRegPattAndInsert /etc/security/limits.conf "soft nofile 51200" "* soft nofile 51200"
  removeLineByRegPattAndInsert /etc/security/limits.conf "hard nofile 51200" "* hard nofile 51200"

  ulimit -n 51200

  removeLineByRegPattAndInsert /etc/sysctl.conf "fs\.file-max" "fs.file-max = 51200"
  removeLineByRegPattAndInsert /etc/sysctl.conf "rmem_max" "net.core.rmem_max = 67108864"
  removeLineByRegPattAndInsert /etc/sysctl.conf "wmem_max" "net.core.wmem_max = 67108864"
  removeLineByRegPattAndInsert /etc/sysctl.conf "netdev_max_backlog" "net.core.netdev_max_backlog = 250000"
  removeLineByRegPattAndInsert /etc/sysctl.conf "somaxconn" "net.core.somaxconn = 4096"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_syncookies" "net.ipv4.tcp_syncookies = 1"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_tw_reuse" "net.ipv4.tcp_tw_reuse = 1"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_tw_recycle" "net.ipv4.tcp_tw_recycle = 0"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_fin_timeout" "net.ipv4.tcp_fin_timeout = 30"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_keepalive_time" "net.ipv4.tcp_keepalive_time = 1200"
  removeLineByRegPattAndInsert /etc/sysctl.conf "ip_local_port_range" "net.ipv4.ip_local_port_range = 10000 65000"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_max_syn_backlog"  "net.ipv4.tcp_max_syn_backlog = 8192"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_max_tw_buckets"  "net.ipv4.tcp_max_tw_buckets = 5000"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_fastopen"  "net.ipv4.tcp_fastopen = 3"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_rmem"  "net.ipv4.tcp_rmem = 4096 87380 67108864"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_wmem"  "net.ipv4.tcp_wmem = 4096 65536 67108864"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_mtu_probing"  "net.ipv4.tcp_mtu_probing = 1"
  removeLineByRegPattAndInsert /etc/sysctl.conf "tcp_congestion_control"  "net.ipv4.tcp_congestion_control = hybla"

  sysctl -p
}

export -f optimizeLinuxForShadowsocksR

# get current server name
setUserCountPerServer() {
    userCount=${1}
    removeLineInFile ${freeServerGlobalEnv} freeServerUserCountPerServer
    if [[ ! -z ${userCount} && "${userCount}" != "0"  ]];then
        echo "export freeServerUserCountPerServer=${userCount}" >> ${freeServerGlobalEnv}
    fi

}
export -f setUserCountPerServer

# get current server name
setServerName() {

  serverName=$(getUserInput "Input \x1b[46m Server Domain \x1b[0m (e.g. server1.free-server.me): " non-empty 3)

  if [[ -z ${serverName} ]]; then

    echoErr "Sever Name should not be empty"

  else

    echo "export freeServerName=${serverName}" >> ${freeServerGlobalEnv}

  fi


}
export -f setServerName

# get current user email
setEmail() {

  email=$(getUserInput "Input \x1b[46m Your Email \x1b[0m (e.g. free-server@gmail.com): " non-empty 3)

  if [[ -z ${email} ]]; then

    echoErr "User Email should not be empty"

  else

    echo "export freeServerUserEmail=${email}" >> ${freeServerGlobalEnv}

  fi


}
export -f setEmail

setupFreeServerUpdating(){
  exitOnFreeServerUpdating

  echo "${currentDateTime}" >> ${updatingFreeServerFilePath}
  export isFreeServerUpdating=1
}
export -f setupFreeServerUpdating

cleanUpFreeServerUpdating(){
  rm ${updatingFreeServerFilePath}
  export isFreeServerUpdating=""
}
export -f cleanUpFreeServerUpdating

exitOnFreeServerUpdating(){
  if [[ ! -z ${isFreeServerUpdating} ]];then
    echoErr "Error: Free Server is already updating. If you want to enforce update, try remove file ${updatingFreeServerFilePath}"
    exit 1
  fi
}
export -f exitOnFreeServerUpdating

installMail(){

  postfixConf=/etc/postfix/main.cf

  echoS "Install mail first"
  #    apt-get purge postfix -y  >> /dev/null 2>&1
  #    apt-get install postfix -y  >> /dev/null 2>&1
  apt-get update -y >> /dev/null 2>&1
  debconf-set-selections <<< "postfix postfix/mailname string ${freeServerName}"
  debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
  apt-get install -y mailutils >> /dev/null 2>&1

  maps=/etc/postfix/generic

  postconf -e \
  "mydomain = ${freeServerName}" \
  "myhostname = ${freeServerName}" \
  "myorigin = \$myhostname" \
  "mydestination = \$myhostname" \
  "relayhost = " \
  "recipient_delimiter = " \
  "smtp_generic_maps = hash:${maps}" \
  "inet_protocols = ipv4" \
  "smtpd_tls_cert_file = ${letsEncryptCertPath}" \
  "smtpd_tls_key_file = ${letsEncryptKeyPath}" \
  "smtp_tls_security_level = encrypt" \
  "smtpd_tls_auth_only = yes" \
  "smtpd_tls_loglevel = 1" \
  "smtpd_tls_received_header = yes" \
  "smtpd_tls_session_cache_timeout = 3600s" \
  "tls_random_source = dev:/dev/urandom"

  echo "www-data root@${freeServerName}" > ${maps}
  postmap /etc/postfix/generic

  systemctl restart postfix

  postsuper -d ALL
  postsuper -d ALL deferred

  echoS "[WARN] If mail doesn't send successfully, try \n\n "
  echoS "apt-get purge postfix -y; apt-get install postfix -y; apt-get purge -y mailutils; apt-get install -y mailutils; systemctl restart postfix"

}

mailNotify() {

  if [[ -z "$(which mail)" ]];then
    installMail
  fi

  if [[ -z "$(which mail)" ]];then
      echoErr "[ERROR] mail command not found."
      return 1
  fi

  hostname ${freeServerName}

  ${binDir}/mail.sh "$@"
}
export -f mailNotify

ensure80443PortIsAvailable(){

    secondsStep5ToEnsure=$1

    if [[ -z $secondsStep5ToEnsure ]]; then
        secondsStep5ToEnsure=60
    fi

    while [[ $secondsStep5ToEnsure -gt 0 ]]; do
        cleanupMemory
        forever stop ${miscDir}/testing-web.js
        service nginx stop
        killProcessesByPattern SimpleHTTPServer
        ((secondsStep5ToEnsure--))
        sleep 5
    done

}

restore80443Process(){
    echo "restore all processes to take 80 and 443"
    if [[ ! -z ${isToInstallOcservCiscoAnyConnect} ]];then
        ${binDir}/restart-ocserv.sh
    fi
    service nginx restart
}

killEnsure80443PortIsAvailablePid() {
    if [[ ! -z $ensure80443PortIsAvailablePid ]]; then
        kill -9 $ensure80443PortIsAvailablePid
        export ensure80443PortIsAvailablePid=""
        sleep 1
    fi
}

# get current user email
prepareLetEncryptEnv() {
    killEnsure80443PortIsAvailablePid
    echo "kill all processes that take 80 and 443"
    ensure80443PortIsAvailable 20 >> /dev/null 2>&1 &
    sleep 10
    export ensure80443PortIsAvailablePid=$!
}
export -f prepareLetEncryptEnv

# get current user email
afterLetEncryptEnv() {
    killEnsure80443PortIsAvailablePid
    restore80443Process
}
export -f afterLetEncryptEnv


enableIptableToConnectInternet(){

    ipt=/sbin/iptables

    sysctl --quiet -w net.ipv4.ip_forward=1

    $ipt -F FORWARD
    $ipt -P FORWARD DROP
    $ipt -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
    $ipt -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
    $ipt -A FORWARD -i vpns+ -o eth0 -j ACCEPT
    $ipt -A FORWARD -i vpns+ -o vpns+ -j ACCEPT

    $ipt -t nat -F POSTROUTING
    $ipt -t nat -A POSTROUTING -o eth0 -j MASQUERADE

}
export -f enableIptableToConnectInternet

updateOcservConf() {

    if [[ ! -f ${ocservConfig} ]]; then
        echoS "Ocserv config file (${ocservConfig}) is not detected. This you may not install it correctly. Exit." "stderr"
        exit 1
    fi


    echoS "Create multiple instance for better connect"
    for (( port=$ocservPortMin; port<=$ocservPortMax; port++ ));do
        duplicateConfByPort ${port}
    done

#    duplicateConfByPort 443

}
export -f updateOcservConf

updateRouteForOcservConf() {

#    mv ${configDir}/ocserv.conf ${configDir}/ocserv.conf.bak
#    downloadFileToFolder ${baseUrlConfigSample}/ocserv.conf ${configDir}
#    if [[ $? == 1 ]]; then
#        echoS "Download failed: ${baseUrlConfigSample}/ocserv.conf"
#        mv ${configDir}/ocserv.conf.bak ${configDir}/ocserv.conf
#        return 1
#    fi
#    rm ${configDir}/ocserv.conf.bak
    updateOcservConf
    ${binDir}/restart-ocserv.sh

}
export -f updateRouteForOcservConf


duplicateConfByPort(){
    port=$1

    newConfName=${ocservConfig}.${port}
    rm ${newConfName}

    cp ${ocservConfig} ${newConfName}

    replaceStringInFile "${newConfName}" __SSL_KEY_FREE_SERVER__ "${letsEncryptKeyPath}"
    replaceStringInFile "${newConfName}" __SSL_CERT_FREE_SERVER__ "${letsEncryptCertPath}"
    replaceStringInFile "${newConfName}" __TCP_PORT__ "${port}"
    replaceStringInFile "${newConfName}" __UDP_PORT__ "${port}"
}

export -f duplicateConfByPort

killProcessesByPort(){
    port=$1

    if [[ -z ${port} ]]; then
	  echoS "Usage: [$FUNCNAME] PORT"
	  return
	fi

    lsof -i tcp:${port} | awk 'NR!=1 {print $2}' | xargs kill
}

export -f killProcessesByPort

isSquidRunning(){
    sleep 3
    isSquidRestarted=$(ps aux | grep squid-auth-pass[wd])
    if [[ -z ${isSquidRestarted} ]];then
        echoErr "[ERROR]: Squid is not running."
        echoErr "[ERROR]: Run 'ps aux | grep squid' for more info"

        squidCacheLog=/var/log/squid/cache.log
        squid3CacheLog=/var/log/squid3/cache.log

        echoErr "[ERROR]: Log of ${squidCacheLog} and ${squid3CacheLog}"

        if [[ -f ${squidCacheLog} ]];then
            cat ${squidCacheLog}
        fi

        if [[ -f ${squid3CacheLog} ]];then
            cat ${squid3CacheLog}
        fi

    fi
}
export -f isSquidRunning

isSSRRunning(){
    sleep 3
    isProcessRunning=$(ps aux | awk '$0~v' v="-c\\ ${shadowsocksRConfigJson}")

    if [[ -z ${isProcessRunning} ]]; then
        echoErr "[ERROR]: SSR is not running."
    fi
}
export -f isSSRRunning

isLetsEncryptInstalled(){

    if [[ ! -s ${letsEncryptKeyPath} ]]; then
      echoErr "The SSL Key file ${letsEncryptKeyPath} is not existed."
    fi

}
export -f isLetsEncryptInstalled

isSPDYUserExisting(){

    username=$1

    isExistInConfigFile=$(gawk "/^${username},/ {print}" ${SPDYConfig})
    isExistInPassWdile=$(gawk "/^${username}:/ {print}" ${SPDYSquidPassWdFile})

    if [[ ! -z ${isExistInConfigFile} || ! -z ${isExistInPassWdile}  ]]; then
        echo ${isExistInConfigFile}
        echo ${isExistInPassWdile}
    fi

}
export -f isSPDYUserExisting


isSSRUserExisting(){

    port=$1
    password=$2

    isPortExistInConfigFile=$(gawk "/^${port},/ {print}" ${shadowsocksRConfig})
    isPassExistInConfigFile=$(gawk "/,${password},/ {print}" ${shadowsocksRConfig})

    if [[ ! -z ${isExistInConfigFile} || ! -z ${isExistInPassWdile}  ]]; then
        echo ${isPortExistInConfigFile}
        echo ${isPassExistInConfigFile}
    fi

}
export -f isSSRUserExisting
