#!/usr/bin/env bash

what="$(ls /etc/ssh/ssh_host_ecdsa_key /dev/null 2>&1)"

if [ ! -f "$what" ]; then
        what="deleted"
fi

echo "ssh_host_ecdsa=$what"
