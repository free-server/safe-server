#!/bin/bash

source /opt/.global-utils.sh

main() {

#  getSpdySslCaPemFile
  installSpdyLay

  cleanupMemory

  installNgHttpX

  uninstallSquid

  generateSquidConf
  linkSquid3DefaultConf
  installSquid
  linkSquid3DefaultConf

  squid3 -f /etc/squid3/squid.conf  -k reconfigure
  sleep 2
  pkill squid3
  pkill squid
  sleep 2

}

installSpdyLay() {

  echoS "Install SpdyLay"
  #npm install -g spdyproxy > /dev/null 2>&1
  apt-get install -y autoconf automake \
  autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libevent-dev \
   2>&1 >> ${loggerStdoutFile}

  rm -rf ${SPDYSpdyLayTarGzName}
  rm -rf ${SPDYSpdyLayFolderName}

  echoS "[INFO] Skipped installing SpdyLay as it's not needed since Chrome supports latest HTTP/2"
  return

#  echoS "Downloading ${SPDYSpdyLayDownloadLink}"

  cd ${gitRepoPath}

  #wget ${SPDYSpdyLayDownloadLink} >> /dev/null 2>&1
  #echoS "Installing, may need 5 minutes..."
  #warnNoEnterReturnKey

  #catchError=$(tar zxf ${SPDYSpdyLayTarGzName} 2>&1 >> ${loggerStdoutFile})
  #exitOnError "${catchError}"

#  cd ${SPDYSpdyLayFolderName}/
#  autoreconf -i >> /dev/null \
#    && automake >> /dev/null \
#    && autoconf >> /dev/null \
#    && ./configure >> /dev/null \
#    && make >> /dev/null \
#    && make install \
#     >> /dev/null

#  ldconfig

  cd ..
  rm -rf ${SPDYSpdyLayTarGzName}
  rm -rf ${SPDYSpdyLayFolderName}

}

installNgHttpX() {

  echoS "Install NgHttpX"
  #npm install -g spdyproxy > /dev/null 2>&1
  catchError=$(apt-get install -y g++ make binutils autoconf automake autotools-dev libtool pkg-config   \
  zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev   \
  libc-ares-dev libjemalloc-dev cython python3-dev python-setuptools apache2-utils 2>&1 >> ${loggerStdoutFile})
  exitOnError "${catchError}"

  warnNoEnterReturnKey

  rm -rf ${SPDYNgHttp2FolderName}
  rm -rf ${SPDYNgHttp2TarGzName}

  echoS "Downloading ${SPDYNgHttp2DownloadLink}"

  cd ${gitRepoPath}

  wget ${SPDYNgHttp2DownloadLink} >> /dev/null 2>&1

  catchError=$(tar zxf ${SPDYNgHttp2TarGzName} 2>&1 >> ${loggerStdoutFile})
  exitOnError "${catchError}"

  cd ${SPDYNgHttp2FolderName}/
  echoS "Installing, may need 5 minutes...(20 minutes on HDD)"
  warnNoEnterReturnKey

  autoreconf -i >> /dev/null && automake >> /dev/null && autoconf >> /dev/null && ./configure >> /dev/null && make >> /dev/null

  make install >> /dev/null

  catchError=$(ldconfig 2>&1 >> ${loggerStdoutFile})
  exitOnError "${catchError}"

  cd ..

  rm -rf ${SPDYNgHttp2FolderName}
  rm -rf ${SPDYNgHttp2TarGzName}

}

generateSquidConf() {
  # SPDYSquidConfig
  replaceStringInFile ${SPDYSquidConfig} FREE_SERVER_BASIC_HTTP_AUTH_PASSWD_FILE ${SPDYSquidPassWdFile}
  replaceStringInFile ${SPDYSquidConfig} SQUID_AUTH_PROCESS ${SPDYSquidAuthSubProcessAmount}
  touch ${SPDYSquidPassWdFile}
  chown proxy.proxy ${SPDYSquidPassWdFile}
  touch ${SPDYConfig}
}


uninstallSquid() {

  echoS "Uninstall Squid"
  killall squid3
  killall squid

  apt-get remove squid3 -y 2>&1 >> /dev/null
  apt-get remove squid -y 2>&1 >> /dev/null
}

installSquid() {

  mkdir -p $SPDYSquidCacheDir

  chmod -R 777 $SPDYSquidCacheDir

  echoS "Install Squid"

  apt-get install squid3 -y 2>&1 >> ${loggerStdoutFile}

}

linkSquid3DefaultConf() {
    config=/etc/squid3/squid.conf
    mkdir -p /etc/squid3
    touch $config
    rm $config
    ln -s ${SPDYSquidConfig} /etc/squid3/squid.conf
}

main "$@"

exit 0

#EOF