#!/bin/bash

source /opt/.global-utils.sh

exitOnFreeServerUpdating

#forever stop ${miscDir}/testing-web.js
#forever start ${miscDir}/testing-web.js
killProcessesByPattern SimpleHTTPServer
killProcessesByPattern http-server.py

sleep 3

cd ${miscDir}/redirect/
# python -m SimpleHTTPServer ${miscWebsitePortHttp} >> /dev/null 2>&1 &
python3 -m http.server ${miscWebsitePortHttp} >> /dev/null 2>&1 &

cd ${miscDir}
python3 http-server.py ${freeServerName} ${miscWebsitePortHttps} ${letsEncryptKeyPath} ${letsEncryptCertPath} >> /dev/null 2>&1 &
