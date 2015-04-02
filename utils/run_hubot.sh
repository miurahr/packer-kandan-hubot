#!/bin/sh

echo "Kandan's Hubot key?";
 
while read inputline
do
KEY="$inputline"
echo $KEY;
 
if [ -z "${KEY}" ];
then
exit
fi
 
done

docker run -d \
  -e "KANDAN_KEY=${KEY}" \
      hubot /usr/bin/runner
