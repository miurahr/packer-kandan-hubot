#!/bin/sh

docker run \
  -e "KANDAN_DBNAME=kandan" \
  -e "KANDAN_DBHOST=postgres" \
  -e "KANDAN_DBUSER=postgres" \
  -e "KANDAN_DBPASS=mysecret" \
  kandan /usr/bin/prepare.sh
