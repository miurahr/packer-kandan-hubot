#!/bin/sh
set -e
# Next environment variables should be set using
# docker -e "VAR=val" command line arguments
# --
# KANDAN_MODE
# HUBOT_TRELLO_KEY
# HUBOT_TRELLO_TOKEN
# HUBOT_TRELLO_BOARD
# --

HUBOT_CONF=/etc/supervisor/conf.d/hubot.conf
KANDAN_CONF=/etc/supervisor/conf.d/kandan.conf

KANDAN_MODE=${MODE:-'development'}

case $KANDAN_MODE in
  'production')
    sed -ri "s/database: kandan/database: ${DBNAME}/g" /srv/kandan/config/database.yml
    sed -ri "s/host: localhost/host: ${DBHOST}/g" /srv/kandan/config/database.yml
    sed -ri "s/username: kandan/username: ${DBUSER}/g" /srv/kandan/config/database.yml
    sed -ri "s/password: something/username: ${DBPASS}/g" /srv/kandan/config/database.yml
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

bundle exec rake db:create db:migrate kandan:bootstrap
bundle exec rake assets:precompile
bundle exec rake kandan:boot_hubot
bundle exec rake kandan:hubot_access_key | awk '{print $6}' > hubot-key

sudo awk '{print "export HUBOT_KANDAN_TOKEN="$0}' /home/hubot/kandan/hubot-key >> /etc/profile.d/hubot.sh 
sudo awk '{print " HUBOT_KANDAN_TOKEN="$0}' /home/hubot/kandan/hubot-key >> ${HUBOT_CONF}

sudo sed -ri "s/command=bundle exec thin start -e production/command=bundle exec thin start -e ${KANDAN_MODE}/g" $KANDAN_CONF

# hubot_trello environment
sudo sed -ri "s/HUBOT_TRELLO_KEY=[^,]*/HUBOT_TRELLO_KEY=${HUBOT_TRELLO_KEY}/g" $HUBOT_CONF
sudo sed -ri "s/HUBOT_TRELLO_TOKEN=[^,]*/HUBOT_TRELLO_TOKEN=${HUBOT_TRELLO_TOKEN}/g" $HUBOT_CONF
sudo sed -ri "s/HUBOT_TRELLO_BOARD=[^,]*/HUBOT_TRELLO_BOARD=${HUBOT_TRELLO_BOARD}/g" $HUBOT_CONF

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

