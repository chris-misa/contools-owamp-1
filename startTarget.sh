#!/bin/bash


#
# Start up owampd process and container running
# chrismisa/contools:owamp as daemon.
#

# owampd starts as root but prefers to drop to user
# level after binding its listening socket.
USERNAME="chmisa"
OWAMP_IMAGE_NAME="chrismisa/contools:owamp"
OWAMP_CONTAINER_NAME="owamp_container"
# The
CONTAINER_LISTEN_PORT="5000"

# Set up owamp directory
mkdir -p /owamp
chown $USERNAME /owamp

# Launch the daemon in native environment
owampd -U $USERNAME

# Pull container
docker pull $OWAMP_IMAGE_NAME

# Launch container as daemon
docker run --rm -d \
  -p ${CONTAINER_LISTEN_PORT}:861 \
  --name="$OWAMP_CONTAINER_NAME" \
  $OWAMP_IMAGE_NAME daemon
