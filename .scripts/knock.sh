#!/bin/bash
HOST=$1
shift
for ARG in "$@"
do
	nmap -Pn --scanflags SYN --host-timeout 100 --max-retries 0 -p $ARG $HOST
done

sleep 1 ; ssh archlinux@$HOST
