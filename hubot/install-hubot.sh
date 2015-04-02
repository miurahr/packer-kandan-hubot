#! /bin/bash
set -e

export HVER=2.6.0
export HROOT=/srv/hubot-${HVER}

# runner user
useradd -s /bin/false hubot

npm install -g mime@1.2.11 qs@0.4.2 coffee-script@1.6.3

wget -O /tmp/hubot.zip https://github.com/github/hubot/archive/v${HVER}.zip && unzip -d /srv /tmp/hubot.zip && rm /tmp/hubot.zip 
install -d /${HROOT}/hubot/bin
install /tmp/hubot/package.json       ${HROOT}/hubot/package.json

git clone https://github.com/miurahr/hubot-kandan.git       ${HROOT}/hubot/node_modules/hubot-kandan
#git clone https://github.com/hubot-scripts/hubot-trello.git ${HROOT}/hubot/node_modules/hubot-trello

cd ${HROOT}
npm install --save hubot-redmine-notifier
npm install --save hubot-jenkins-notifier
npm install
make package

install /tmp/hubot/hubot-scripts.json ${HROOT}/hubot/hubot-scripts.json
install /tmp/hubot/external-scripts.json ${HROOT}/hubot/external-scripts.json

cd ${HROOT}/hubot
npm install faye@1.0.1
npm install ntwitter
#npm install node-trello

chown -R hubot:hubot ${HROOT}

install /tmp/hubot/hubot.conf  /etc/supervisor/conf.d/

rm -rf /tmp/hubot
