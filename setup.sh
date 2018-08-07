#!/bin/bash

#
# Set up nodes in owamp experiment
#
# Mostly a routine copied from the owamp Dockerfile
# then a routine copied from docker's instalation instructions
#

OWAMP_SOURCE_DIR="http://software.internet2.edu/sources/owamp/"
OWAMP_SOURCE_FILE="owamp-3.4-10.tar.gz"

# Get dependencies
apt-get update
apt-get install -y gcc make wget libi2util-dev i2util-tools

# Download owamp source
wget ${OWAMP_SOURCE_DIR}${OWAMP_SOURCE_FILE}

# Make a clean directory to untar into so we can cd owamp-* later
mkdir -p owamp
tar xvf ${OWAMP_SOURCE_FILE} -C owamp
cd owamp-* && ./configure && make && make install

# Set up docker
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-ket add -

add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

apt-get update
apt-get install docker-ce