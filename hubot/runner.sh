#!/bin/sh
set -e

#
# need KANDAN_KEY as environmental variable

HUBOT_CONF=/etc/supervisor/conf.d/hubot.conf

# hubot conf
sed -ri "s/HUBOT_KANDAN_TOKEN=[^,]*/HUBOT_KANDAN_TOKEN=${KANDAN_KEY}/g" ${HUBOT_CONF}

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

