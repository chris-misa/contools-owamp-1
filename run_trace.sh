#!/bin/bash

TRACE_CMD_ARGS="-e net:net_dev_queue -e net:net_dev_xmit -e net:napi_gro_frags_entry -e net:netif_receive_skb --date"
PARSE_CMD="${OLD_PWD}/parse_stream parse_stream.conf"

for arg in ${IPERF_ARGS[@]}
do
  echo $arg >> file_list
  # Start iperf
  if [ $arg != "nop" ]
  then
    iperf -c $IPERF_TARGET_IPV4 -d -i 100 -b $arg -t 0 \
      > ${arg}.iperf &
    IPERF_PID=$!
  fi

  #
  # Native owping for control
  #
  echo $B Native control $B
  # Run ping in background
  $NATIVE_PING_CMD $PING_ARGS $TARGET_IPV4 \
    > native_control_${TARGET_IPV4}_${arg}.owping &

  echo "  pinging. . ."
  
  PING_PID=`ps -e | grep owping | sed -E 's/ *([0-9]+) .*/\1/'`
  echo "  got owping pid: $PING_PID"
  
  
  wait $PING_PID
  echo "  owping returned"
  
  $PAUSE_CMD

  #
  # Container pings for control
  #
  echo $B Container control $B
  # Start ping in container
  docker exec -i $PING_CONTAINER_NAME \
    $CONTAINER_PING_CMD $PING_ARGS $TARGET_IPV4 \
    > container_control_${TARGET_IPV4}_${arg}.owping &
  echo "  pinging. . ."

  $PAUSE_CMD

  PING_PID=`ps -e | grep owping | sed -E 's/ *([0-9]+) .*/\1/'`
  echo "  got ping pid: $PING_PID"
  
  while test -d "/proc/$PING_PID" 2> /dev/null; do sleep 1; done;
  echo "  owping returned"

  $PAUSE_CMD

  #
  # Container pings with monitoring
  #
  echo $B Container / native monitored $B
  
  trace-cmd record $TRACE_CMD_ARGS \
	  -o container_monitored_${TARGET_IPV4}_${arg}.dat &
  MONITOR_PID=$!
  echo "  monitor running with pid: ${MONITOR_PID}"
  
  $PAUSE_CMD

  docker exec -i $PING_CONTAINER_NAME \
    $CONTAINER_PING_CMD $PING_ARGS $TARGET_IPV4 \
    > container_monitored_${TARGET_IPV4}_${arg}.ping &
  echo "  container pinging. . ."

  PING_PID=`ps -e | grep owping | sed -E 's/ *([0-9]+) .*/\1/'`
  echo "  got container owping pid $PING_PID"

  # Run ping in background
  $NATIVE_PING_CMD $PING_ARGS $TARGET_IPV4 \
    > native_monitored_${TARGET_IPV4}_${arg}.ping &
  NAT_PING_PID=$!
  echo "  native pinging. . . (pid $NAT_PING_PID)"
  
  
  while test -d "/proc/$PING_PID" 2> /dev/null \
	  || test -d "/proc/$NAT_PING_PID" 2> /dev/null
	do sleep 1; done;
  echo "  owpings returned"
  
  $PAUSE_CMD
  
  kill -INT $MONITOR_PID
  echo "  killed monitor"
  
  $PAUSE_CMD

  trace-cmd report container_monitored_${TARGET_IPV4}_${arg}.dat \
	  > container_monitored_${TARGET_IPV4}_${arg}.trace
  rm container_monitored_${TARGET_IPV4}_${arg}.dat
  echo "  converted raw trace data"
  cat container_monitored_${TARGET_IPV4}_${arg}.trace \
	  | $PARSE_CMD \
	  > container_monitored_${TARGET_IPV4}_${arg}.latency
  echo "  converted to latencies"

  if [ $arg != "nop" ]
  then
    kill -INT $IPERF_PID
    echo "  killed iperf"
  fi

  $PAUSE_CMD

done
