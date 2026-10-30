#!/bin/bash

what=""

if [ -d /etc/pve ]; then
   what="pve"
else
   what="none"
fi

echo "check_pve=$what"
