#!/bin/bash

source /opt/.global-utils.sh

SPDYName=$1
SPDYPassword=$2
SPDYPort=$3

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo "$0 SPDYName SPDYPassword SPDYPort"
  exit 0
fi

if [[ -z ${SPDYName} || -z ${SPDYPassword} || -z ${SPDYPort} ]]; then
  echoS "$0 SPDYName SPDYPassword SPDYPort"
  exit 1
fi

removeLineInFile  ${SPDYConfig} "${SPDYName},${SPDYPassword},${SPDYPort}"
removeLineInFile  ${SPDYSquidPassWdFile} "${SPDYName}:"

${binDir}/restart-spdy-nghttpx-squid.sh

echoS "HTTP2/SPDY deleted for ${SPDYName} from ${SPDYConfig} and ${SPDYSquidPassWdFile}"
