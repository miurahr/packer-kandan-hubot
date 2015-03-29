#!/bin/bash

if [ -e /run/docker/kandan-hubot.pid ]; then
  DPID=`cat /run/docker/kandan-hubot.pid`
else
  echo "Warn: cannot find container id file! instead use most recent docker container."
  DPID=`docker ps -q -l`
fi

DADDRESS=`docker port ${DPID} 22`
DPORT=${DADDRESS#0.0.0.0:}

if [ "${DPORT}" != "" ]; then
  ssh -p $DPORT -l root -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no localhost
else
  echo Error! Can not find docker guest ssh port.
  exit 1
fi
