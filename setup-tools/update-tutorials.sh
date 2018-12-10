#!/bin/bash

source /opt/.global-utils.sh

main() {

  updateServerUrl
}

updateServerUrl() {
  # serverUrlPlaceholder=https://server1.free-server.me:443/
  export serverUrlPlaceholder=__SERVER_URL__

  echoS "Update Tutorial: replace __SERVER_URL__ to ${httpsFreeServerUrl}"
  # miscDir
  find ${miscDir} -type f -exec bash -c "replaceStringInFile {} ${serverUrlPlaceholder} ${httpsFreeServerUrl} " \;

}

main "$@"

exit 0

#EOF
