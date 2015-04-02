#!/bin/sh

KANDAN_DBNAME=kandan
KANDAN_DBUSER=postgres
KANDAN_DBPASS=mysecret

docker run -d --name postgres -e "POSTGRES_PASSWORD=${KANDAN_DBPASS}" -e "POSTGRES_USER=${KANDAN_DBUSER}" -d postgres

docker run --name "kandan"  \
  --link kandan-postgres:postgres \
  -e "KANDAN_DBNAME=${KANDAN_DBNAME}" \
  -e "KANDAN_DBHOST=${POSTGRES_PORT_5432_TCP_ADDR}" \
  -e "KANDAN_DBUSER=${KANDAN_DBUSER}" \
  -e "KANDAN_DBPASS=${KANDAN_DBPASS}" \
  kandan /usr/bin/prepare.sh

sleep 15

docker start -d -p 3000:3000 kandan
