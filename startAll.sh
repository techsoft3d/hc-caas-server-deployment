#!/bin/bash
#export AWS_ACCESS_KEY_ID=DUMMY
#export AWS_SECRET_ACCESS_KEY=DUMMY

if [ -z "$nomongo" ]; then
    echo "Starting MongoDB because nomongo environment variable is not set"
    mongod --config /etc/mongod.conf &
else
    echo "nomongo environment variable is set. Not starting MongoDB"
fi

cd /app/caasComplete

#npm update ts3d.hc.caas --save
#npm update ts3d.hc.caas.usermanagement --save

xvfb-run "--auto-servernum" "-s" "-screen 0 640x480x24" "$(which node)" proxyAll
