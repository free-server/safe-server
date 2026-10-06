#!/bin/bash

source /opt/.global-utils.sh

# Verify TLS and HTTP, rather than leaving a raw TCP connection on the listener.
# Pin the check to localhost while retaining the certificate's hostname.
if ! curl --silent --show-error --fail --connect-timeout 5 --max-time 15 \
    --resolve "${freeServerName}:${miscWebsitePortHttps}:127.0.0.1" \
    --output /dev/null "https://${freeServerName}:${miscWebsitePortHttps}/"; then
    /bin/bash "${binDir}/restart-misc.sh"
fi
