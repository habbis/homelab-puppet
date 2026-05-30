#!/usr/bin/env bash

what="$(find /etc -name ssh_host_ecdsa_key)"

if [ ! -n "$what" ]; then
        what="deleted"
fi

echo "ssh_host_ecdsa_key=$what"
