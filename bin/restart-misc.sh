#!/bin/bash

source /opt/.global-utils.sh

#forever stop ${miscDir}/testing-web.js
#forever start ${miscDir}/testing-web.js
killProcessesByPattern SimpleHTTPServer
killProcessesByPattern http-server.py

sleep 3

cd ${miscDir}/redirect/
python -m SimpleHTTPServer ${miscWebsitePortHttp} >> /dev/null 2>&1 &

cd ${miscDir}
python http-server.py ${freeServerName} ${miscWebsitePortHttps} ${letsEncryptKeyPath} ${letsEncryptCertPath} >> /dev/null 2>&1 &