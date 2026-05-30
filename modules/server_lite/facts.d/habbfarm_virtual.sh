#!/bin/bash

if ! which virt-what > /dev/null 2>&1 ; then
	echo "habbfarm_virtual=virt-what not found"
	exit 0
fi

what="$(virt-what | xargs)"

if [ -z "$what" ]; then
	what=physical
fi

echo "habbfarm_virtual=$what"

