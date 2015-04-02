#!/bin/sh
set -e

# Next environment variables should be set using
# docker -e "VAR=val" command line arguments
# --
# KANDAN_DBHOST
# KANDAN_DBUSER
# KANDAN_DBPASS
# KANDAN_DBNAME
# --

KANDAN_CONF=/etc/supervisor/conf.d/kandan.conf
KANDAN_DB_CONF=/srv/kandan/config/database.yml
KROOT=/srv/kandan

sed -ri "s/database: kandan/database: ${KANDAN_DBNAME}/g" ${KANDAN_DB_CONF}
sed -ri "s/host: localhost/host: ${KANDAN_DBHOST}/g" ${KANDAN_DB_CONF}
sed -ri "s/username: kandan/username: ${KANDAN_DBUSER}/g" ${KANDAN_DB_CONF}
sed -ri "s/password: something/username: ${KANDAN_DBPASS}/g" ${KANDAN_DB_CONF}
export RAILS_ENV=production

cd ${KROOT}
sudo -u kandan -E bundle exec rake db:create db:migrate kandan:bootstrap
sudo -u kandan -E bundle exec rake assets:precompile
sudo -u kandan -E bundle exec rake kandan:boot_hubot
sudo -u kandan -E bundle exec rake kandan:hubot_access_key | grep -oP "(?<=Your hubot access key is )[^ ]*" > hubot-key
HUBOT_KEY=`cat hubot-key`

echo "Hubot key is: ${HUBOT_KEY}"
echo -n

exit 0
