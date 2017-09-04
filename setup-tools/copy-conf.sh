#!/usr/bin/env bash

source /opt/.global-utils.sh

main() {
 copyConf
 fixLostFiles
}

copyConf() {
    cp -r ${configSampleDir}/* ${configDir}/
}

fixLostFiles(){
    if [[ ! -f ${shadowsocksRConfig} ]]; then
      touch ${shadowsocksRConfig}
    fi
}

main "$@"


exit 0
