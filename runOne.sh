#!/bin/bash

#
# Test of ftrace/latency under varying load provided by iperf
#


B="----------------"


TARGET_IPV4="10.10.1.2"

IPERF_TARGET_IPV4="10.10.1.2"

PING_ARGS="-i 1f -c 10 -R"

NATIVE_PING_CMD="owping"
CONTAINER_PING_CMD="owping"

PING_CONTAINER_IMAGE="chrismisa/contools:owamp"
PING_CONTAINER_NAME="owamp-container"

OWAMP_NET="owamp_net"

PAUSE_CMD="sleep 5"

DATE_TAG=`date +%Y%m%d%H%M%S`
META_DATA="Metadata"

# declare -a IPERF_ARGS=("1M" "3M" "10M" "32M" "100M" "316M" "1G" "3G" "10G")
# declare -a IPERF_ARGS=("nop" "1M" "10M" "100M" "1G" "10G")
# declare -a IPERF_ARGS=("nop" "500K" "1M" "100M" "1G" "10G")
declare -a IPERF_ARGS=("1M")

OLD_PWD=$(pwd) # used in the scripts referenced below to get at functions in this dir

RUN_TRACE="${OLD_PWD}/run_trace.sh"

mkdir $DATE_TAG
cd $DATE_TAG

# Get some basic meta-data
echo "uname -a -> $(uname -a)" >> $META_DATA
echo "docker -v -> $(docker -v)" >> $META_DATA
echo "lsb_release -a -> $(lsb_release -a)" >> $META_DATA
echo "sudo lshw -> $(sudo lshw)" >> $META_DATA

# Start ping container as service
docker run -itd \
  --name=$PING_CONTAINER_NAME \
  --entrypoint=/bin/bash \
  --network=$OWAMP_NET \
  $PING_CONTAINER_IMAGE
docker exec $PING_CONTAINER_NAME mkdir -p /tmp
echo $B Started $PING_CONTAINER_NAME $B

$PAUSE_CMD

#
# Set variables for run_trace.sh
#
echo $B Running trace $B

# mkdir inner_dev
# cd inner_dev
source $RUN_TRACE
# cd ..

docker stop $PING_CONTAINER_NAME
docker rm $PING_CONTAINER_NAME
echo $B Stopped container $B

echo Done.
