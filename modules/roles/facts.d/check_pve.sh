#!/bin/bash

what=""
pve_path="$(ls -la /etc/pve)"

if [ -z "$pve_path" ]; then
   what="none"
else
   what="pve"
fi

echo "check_pve=$what"
