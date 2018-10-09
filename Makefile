all: parse_stream

parse_stream: parse_stream.c libftrace.h libftrace.o
	gcc -O2 -o parse_stream parse_stream.c libftrace.o -pthread

libftrace.o: libftrace.h libftrace.c
	gcc -O2 -c -o libftrace.o libftrace.c -lpthread

clean:
	rm -f parse_stream libftrace.o

