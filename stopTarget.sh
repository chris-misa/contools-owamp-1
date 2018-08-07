#!/bin/bash

#
# Stop daemons running on target
#

OWAMP_PID=`cat /owamp/info/owampd.pid`
OWAMP_CONTAINER_NAME="owamp_container"

kill $OWAMP_PID
docker stop $OWAMP_CONTAINER_NAME
