#! /bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# runner user
useradd -s /bin/false kandan

# install dependency
apt-get -y install \
  ruby1.9.1-dev ruby-bundler \
  libpq5 sqlite3 libmysqlclient18 \
  libcurl3 libcurl3-nss libpcre3 libxml2 libxslt1.1 \
  libreadline5 \
  libmysqlclient-dev libsqlite3-dev libpq-dev \
  libcurl4-openssl-dev libpcre3-dev libxml2-dev libxslt-dev \
  libreadline-gplv2-dev

cd /srv
git clone https://github.com/miurahr/kandan.git
KROOT=/srv/kandan
cd ${KROOT}
git checkout i18n

gem install execjs
bundle install

install -m 644 /tmp/kandan/database.yml ${KROOT}/config/database.yml
sed -ri 's/config.serve_static_assets = false/config.serve_static_assets = true/g' ${KROOT}/config/environments/production.rb

chown -R kandan:kandan ${KROOT}

# cleanup dev files
apt-get -y remove \
  libmysqlclient-dev libsqlite3-dev libpq-dev \
  libcurl4-openssl-dev libpcre3-dev libxml2-dev libxslt-dev \
  libreadline-gplv2-dev

rm -rf /tmp/kandan
