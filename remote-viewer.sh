#!/bin/bash

VV_FILE="$1"
RANDOM_PORT=7231
SSH_PROXY_USER="ssh User"
SSH_PROXY="Enter SSH Proxy here"
SSH_PROXY_PORT=22

if [ "$VV_FILE" == "" ]
then
  echo 'Usage: ./remote-viewer.sh <VV File>'
  exit 1
fi

if [ ! -f $VV_FILE ]
then
  echo "Could not find VV file"
  exit 1
fi

REMOTE_VNC_HOST=`cat $VV_FILE | grep '^host=' | sed -r 's/host=(.*)/\1/g' | head -1` 2>/dev/null
REMOTE_VNC_PORT=`cat $VV_FILE | grep '^port=' | sed -r 's/port=(.)/\1/g'` 2>/dev/null

# Update VV file
#  Update first ocurence of host
sed -i "0,/host=.*/{s/host=.*/host=127.0.0.1/}" $VV_FILE 2>/dev/null
#  Update port
sed -i "s/^port=.*/port=${RANDOM_PORT}/g" $VV_FILE 2>/dev/null

bash <<EOF &
while true
do
  if netstat -an | grep ${RANDOM_PORT} 2>/dev/null >/dev/null
  then
    break
  else
    sleep 2
  fi
done
remote-viewer ${VV_FILE} 2>&1 >/dev/null
EOF

ssh ${SSH_PROXY_USER}@${SSH_PROXY} -p ${SSH_PROXY_PORT} -L ${RANDOM_PORT}:${REMOTE_VNC_HOST}:${REMOTE_VNC_PORT}

