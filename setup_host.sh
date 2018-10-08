#
# Script to set up the host node in owamp daemon-mode experiment
#

# This must be the name of the host's experimental iface
PARENT_IFACE="eno1d1"

# Name for the docker-macvlan network
NET_NAME="owamp_net"

CONTAINER_IMAGE="chrismisa/contools:owamp"

# Name for daemon container
CONTAINER_NAME="owamp-container"


# Install the stuff
source setup.sh

# Create a macvlan network
docker network create -d macvlan \
	--subnet=10.10.1.0/24 \
	--gateway=10.10.1.1 \
	--aux-address="client=10.10.1.2" \
	-o parent=$PARENT_IFACE \
	$NET_NAME

# Spin up container in daemon-mode
docker run --rm -d --network=$NET_NAME \
        --name=$CONTAINER_NAME
	$CONTAINER_IMAGE daemon

# Start native owamp
owampd -f

echo Setup done.
