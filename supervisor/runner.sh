#!/bin/sh
set -e

# Next environment variables should be set using
# docker -e "VAR=val" command line arguments
# --
# KANDAN_MODE
# KANDAN_DBHOST
# KANDAN_DBUSER
# KANDAN_DBPASS
# KANDAN_DBNAME
# HUBOT_TRELLO_KEY
# HUBOT_TRELLO_TOKEN
# HUBOT_TRELLO_BOARD
# --

HUBOT_CONF=/etc/supervisor/conf.d/hubot.conf
KANDAN_CONF=/etc/supervisor/conf.d/kandan.conf
KANDAN_DB_CONF=/srv/kandan/config/database.yml
${HROOT}=/srv/hubot-2.6.0
${KROOT}=/srv/kandan

KANDAN_MODE=${MODE:-'development'}

case $KANDAN_MODE in
  'production')
    sed -ri "s/database: kandan/database: ${KANDAN_DBNAME}/g" ${KANDAN_DB_CONF}
    sed -ri "s/host: localhost/host: ${KANDAN_DBHOST}/g" ${KANDAN_DB_CONF}
    sed -ri "s/username: kandan/username: ${KANDAN_DBUSER}/g" ${KANDAN_DB_CONF}
    sed -ri "s/password: something/username: ${KANDAN_DBPASS}/g" ${KANDAN_DB_CONF}
    export RAILS_ENV=production
    ;;
  'development')
    export RAILS_ENV=development
    ;;
  'test')
    export RAILS_ENV=test
    ;;
  default)
    exit 1
    ;;
esac

cd ${KROOT}
bundle exec rake db:create db:migrate kandan:bootstrap
bundle exec rake assets:precompile
bundle exec rake kandan:boot_hubot
bundle exec rake kandan:hubot_access_key | awk '{print $6}' > hubot-key

sudo awk '{print "export HUBOT_KANDAN_TOKEN="$0}' ${KROOT}/hubot-key >> /etc/profile.d/hubot.sh
sudo awk '{print " HUBOT_KANDAN_TOKEN="$0}' ${KROOT}/hubot-key >> ${HUBOT_CONF}

sudo sed -ri "s/command=bundle exec thin start -e production/command=bundle exec thin start -e ${KANDAN_MODE}/g" $KANDAN_CONF

# hubot_trello environment
sudo sed -ri "s/HUBOT_TRELLO_KEY=[^,]*/HUBOT_TRELLO_KEY=${HUBOT_TRELLO_KEY}/g" $HUBOT_CONF
sudo sed -ri "s/HUBOT_TRELLO_TOKEN=[^,]*/HUBOT_TRELLO_TOKEN=${HUBOT_TRELLO_TOKEN}/g" $HUBOT_CONF
sudo sed -ri "s/HUBOT_TRELLO_BOARD=[^,]*/HUBOT_TRELLO_BOARD=${HUBOT_TRELLO_BOARD}/g" $HUBOT_CONF

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

