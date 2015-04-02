#! /bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install \
  supervisor \
  build-essential \
  curl \
  unzip \
  git-core \
  gcc \
  g++ \
  make
  
curl -sL https://deb.nodesource.com/setup | bash - 
apt-get install -y nodejs

# add supervisor config file
mkdir -p /var/log/supervisor /etc/supervisor/conf.d
