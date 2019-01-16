#!/bin/bash

source /opt/.global-utils.sh

main() {

  updateServerUrl
}

updateServerUrl() {
  # serverUrlPlaceholder=https://server1.free-server.me:443/
  export serverUrlPlaceholder=__SERVER_URL__
  export serverNamePlaceholder=__SERVER_DOMAIN_NAME__

  echoS "Update Tutorial: replace __SERVER_URL__ to ${httpsFreeServerUrl}"
  echoS "Update Tutorial: replace __SERVER_DOMAIN__ to ${freeServerName}"
  # miscDir
  find ${miscDir} -type f -exec bash -c "replaceStringInFile {} ${serverUrlPlaceholder} ${httpsFreeServerUrl} " \;
  find ${miscDir} -type f -exec bash -c "replaceStringInFile {} ${serverNamePlaceholder} ${freeServerName} " \;

}

main "$@"

exit 0

#EOF
