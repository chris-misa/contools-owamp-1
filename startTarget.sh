#!/bin/bash


#
# Start up owampd process and container running
# chrismisa/contools:owamp as daemon.
#

# owampd starts as root but prefers to drop to user
# level after binding its listening socket.
USERNAME="chmisa"

# Set up owamp directory
mkdir -p /owamp
chown $USERNAME /owamp

owampd -U $USERNAME


