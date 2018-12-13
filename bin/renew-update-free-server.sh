#!/bin/bash

source /opt/.global-utils.sh

main() {
  exitOnFreeServerUpdating
  mainUpdate
}


mainUpdate() {
  cd ${gitRepoFreeServerPath}
  git stash
  currentGitCommitHash=$(git rev-parse HEAD)
  git pull
  newGitCommitHash=$(git rev-parse HEAD)
  if [[ "${currentGitCommitHash}" != "${newGitCommitHash}" ]];then
    mailNotify "Updating - Safe server update started at $(getCurrentDateTime)"
    /bin/bash ./install-shadowsocks-spdy.sh
    mailNotify "Updated - Safe server update finished at $(getCurrentDateTime)"
  else
    echoErr "[WARN] FreeServerUpdate: The git remote ${freeServerRepo} is identical as local git repo ${gitRepoFreeServerPath}"
    git log --name-status HEAD^..HEAD
  fi

}

main "$@"

exit 0
