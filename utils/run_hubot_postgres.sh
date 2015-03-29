#!/bin/sh

base=$(dirname $0)
. $base/kandan-hubot.cf

if [ ! -d /run/docker ]; then
  sudo mkdir -p /run/docker
  sudo chmod 777 /run/docker
fi

docker run -d --name kandan-postgres -e "POSTGRES_PASSWORD=${KANDAN_DBPASS}" -e "POSTGRES_USER=${KANDAN_DBUSER}" -d postgres
DPID=`docker ps -q -l`
echo $DPID > /run/docker/kandan-postgres.pid

sleep 30

docker run -d -p 22 -p 3000:3000 --name "kandan-hubot"  \
  --link kandan-postgres:postgres \
  -e "KANDAN_MODE=${KANDAN_MODE}" \
  -e "KANDAN_DBNAME=${KANDAN_DBNAME}" \
  -e "KANDAN_DBHOST=${POSTGRES_PORT_5432_TCP_ADDR}" \
  -e "KANDAN_DBUSER=${KANDAN_DB_USER}" \
  -e "KANDAN_DBPASS=${KANDAN_DBPASS}" \
  miurahr/kandan-hubot /usr/bin/runner

DPID=`docker ps -q -l`
echo $DPID > /run/docker/kandan-hubot.pid
