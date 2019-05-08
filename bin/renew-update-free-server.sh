#!/bin/bash

source /opt/.global-utils.sh

main() {
  exitOnFreeServerUpdating
  mustExportGlobalEnvBeforeAutoUpdate
  mainUpdate
}

mustExportGlobalEnvBeforeAutoUpdate() {

  if [[ -z "${currentLoggedInUserGlobalEnv}" ]];then
     mailNotify "[ERROR] AutoUpdate: currentLoggedInUserGlobalEnv must be set in latest .global-utils.sh. Try manually reinstall SafeServer"
     exit 1
  fi

  if [[ ! -f "${currentLoggedInUserGlobalEnv}" ]];then
     mailNotify "[ERROR] AutoUpdate: file ${currentLoggedInUserGlobalEnv} must be populated before auto-upgrade. Try manually reinstall SafeServer "
     exit 1
  fi

  env - `cat ${currentLoggedInUserGlobalEnv}` /bin/bash
}


mainUpdate() {
  cd ${gitRepoFreeServerPath}

  git fetch
  currentGitCommitHash=$(git rev-parse HEAD)
  newGitCommitHash=$(git rev-parse master@{upstream})

  if [[ "${currentGitCommitHash}" != "${newGitCommitHash}" ]];then
    git stash
    git pull
    mailNotify "[Start] Safe server update started at $(getCurrentDateTime)"
    /bin/bash ./install-shadowsocks-spdy.sh
    /bin/bash ${setupToolsDir}/update-tutorials.sh
    /bin/bash ${binDir}/restart-shadowsocks-r.sh
    /bin/bash ${binDir}/restart-spdy-nghttpx-squid.sh
    mailNotify "[End] Safe server update finished at $(getCurrentDateTime)"
  else
    echoErr "[WARN] FreeServerUpdate: The git remote ${freeServerRepo} is identical as local git repo ${gitRepoFreeServerPath}"
    git log --name-status HEAD^..HEAD
  fi

}

main "$@"

exit 0
