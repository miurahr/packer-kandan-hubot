#!/bin/sh

base=$(dirname $0)
. $base/kandan-hubot.cf

docker run -d -p 22 -p 3000:3000 \
  -e "KANDAN_MODE=${KANDAN_MODE}" \
  -e "KANDAN_DBNAME=${KANDAN_DBNAME}" \
  -e "KANDAN_DBHOST=${KANDAN_DBHOST}" \
  -e "KANDAN_DBUSER=${KANDAN_DBUSER}" \
  -e "KANDAN_DBPASS=${KANDAN_DBPASS}" \
  miurahr/kandan-hubot /usr/bin/runner

if [ ! -d /run/docker ]; then
  sudo mkdir -p /run/docker
  sudo chmod 777 /run/docker
fi

DPID=`docker ps -q -l`
echo $DPID > /run/docker/kandan-hubot.pid
