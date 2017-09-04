#!/bin/bash

source /opt/.global-utils.sh

#forever stop ${miscDir}/testing-web.js
#forever start ${miscDir}/testing-web.js

cd ${miscDir}

python -m SimpleHTTPServer 80 >> /dev/null 2>&1 &