#!/usr/bin/env bash

what="$(ls /etc/ssh/ssh_host_ecdsa_key)"

if [ ! -f "$what" ]; then
        what="deleted"
fi

echo "ssh_host_ecdsa=$what"
