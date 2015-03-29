#!/bin/bash

if [ -e /run/docker/kandan-hubot.pid ]; then
  DPID=`cat /run/docker/kandan-hubot.pid`
else
  exit 1
fi

docker stop $DPID
