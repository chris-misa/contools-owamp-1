#
# Script to set up a client node in owamp daemon-mode experiment
#

# This must be the name of the host's experimental iface
PARENT_IFACE="eno1d1"

# Name for the docker-macvlan network
NET_NAME="owamp_net"

# Install the stuff
source ./setup.sh

# Create a macvlan network
docker network create -d macvlan \
	--subnet=10.10.1.0/24 \
	--gateway=10.10.1.1 \
	--aux-address="client=10.10.1.2" \
	-o parent=$PARENT_IFACE \
	$NET_NAME


echo Setup done.
