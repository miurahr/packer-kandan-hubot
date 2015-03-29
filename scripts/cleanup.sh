#! /bin/bash
set -e

# clean apt caches
apt-get clean
apt-get -y autoremove
find /var/lib/apt/lists/ -type f -exec rm -f {} \;

if [ -d /tmp/supervisor ]; then
  rm -rf /tmp/supervisor
fi
