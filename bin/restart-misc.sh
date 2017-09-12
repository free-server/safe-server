#!/bin/bash

source /opt/.global-utils.sh

#forever stop ${miscDir}/testing-web.js
#forever start ${miscDir}/testing-web.js

cd ${miscDir}/redirect/
python -m SimpleHTTPServer 80 >> /dev/null 2>&1 &

python http-server.py ${freeServerName} ${miscWebsitePort} ${letsEncryptCertPath} >> /dev/null 2>&1 &