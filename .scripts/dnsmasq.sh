#!/bin/sh

dnsmasq \
	--strict-order \
	--except-interface=lo \
	--bind-dynamic \
	--interface=virbr0 \
	--dhcp-option=3 \
	--no-resolv \
	--ra-param=*,0,

