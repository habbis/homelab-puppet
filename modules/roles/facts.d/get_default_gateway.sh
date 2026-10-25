#!/bin/bash

what="$(ip route |grep default |awk '{print $3}')"

if [ -z "$what" ]; then
   what="$(netstat -r |grep default |awk '{print $2}')"
fi

echo "get_default_gateway=$what"
