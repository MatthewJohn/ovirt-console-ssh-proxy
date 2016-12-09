#!/bin/bash

VV_FILE="$1"
RANDOM_PORT=7231
SSH_PROXY="$2"
SSH_PORXY_PORT=22

ssh root@ -L 7231:${REMOTE_VNC_HOST}:${REMOTE_VNC_PORT} -n -N &
SSH_PID="$!"

sed -i  ${VV_FILE}

remote-viewer


kill -15 $SSH_PID
