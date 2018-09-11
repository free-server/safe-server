#!/usr/bin/env bash

source /opt/.global-utils.sh

usage="$0 sendTo titleToSend bodyToSend fromName fromAddr replyTo"

if [ "x$1" = "x-h" -o "x$1" = "x--help" ]
then
  echo ${usage}
  echo "e.g."
  echo ""
  echo $0 "j.doe@example.com" "Test title" "Test body" "Safe Server" "test@free-server.me" "j.doe@gmail.com"
  exit 0
fi

titleToSend=$1
bodyToSend=$2

sendTo=$3

fromName=$4
fromAddr=$5

replyTo=$6

if [[ -z "$titleToSend" ]];then
	echo "[ERROR] usage: ${usage}"
	exit 1
fi

if [[ -z "$bodyToSend" ]];then
	bodyToSend=$titleToSend

fi

if [[ -z "$sendTo" ]];then
	sendTo=${freeServerUserEmail}
fi

if [[ -z "$fromName" ]];then
	fromName="Safe Server"
fi

if [[ -z "$fromAddr" ]];then
	fromAddr="no-reply@${freeServerName}"
fi

if [[ -z "$replyTo" ]];then
	replyTo=${freeServerUserEmail}
fi

cmd="echo \"${bodyToSend}\" | mail -s \"\$(echo -e \"${titleToSend}\nFrom: ${fromName} <${fromAddr}>\nReply-to: ${replyTo}\nContent-Type: text/html\n\")\" ${sendTo} ${freeServerUserEmail}"

echoS "[INFO] Start to execute:"
echo "${cmd}"

eval "${cmd}"