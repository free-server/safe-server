#!/usr/bin/env bash

source /opt/.global-utils.sh

# clusterDefFilePath in /opt/.global-utils.sh

init() {
  createConfigFile
}

createConfigFile() {
  touch ${clusterDefFilePath}
  echo "# Guide: Put a server domain for SSH Mutual Auth per line, with Linux User. E.g: " >> ${clusterDefFilePath}
  echo "# root@vpn1.free-server.me" >> ${clusterDefFilePath}
  echo "# root@vpn2.free-server.me" >> ${clusterDefFilePath}
}

linkToShortCut() {
  ln -s ${binDir}/cluster-rsync.sh ${freeServerRoot}/cluster-rsync
  ln -s ${binDir}/cluster-restart.sh ${freeServerRoot}/cluster-restart
  ln -s ${binDir}/cluster-deploy-ssh-mutual-auth.sh ${freeServerRoot}/cluster-deploy-ssh-mutual-auth
  ln -s ${binDir}/cluster-deploy-ssh-mutual-auth-accept.sh ${freeServerRoot}/cluster-deploy-ssh-mutual-auth-accept
}

init "$@"
