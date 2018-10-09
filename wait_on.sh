function wait_on {
	for pid in $@
	do
		echo "waiting on $pid"
		while [ -n "`ps -e | grep $pid`" ]
		do sleep 1
		done
	done
}
