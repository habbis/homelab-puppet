#!/bin/bash

if ! which keepalived > /dev/null 2>&1 ; then
   echo "check_keepalived=keepalived not found"
   exit 0
fi

if ! /etc/keepalived/keepalived.conf > /dev/null 2>&1 ; then
   echo "check_keepalived=keepalived config not found"
   exit 0
fi

what="$(grep "state" /etc/keepalived/keepalived.conf |xargs| awk '{print $2}')"

if [ -z "$what" ]; then
   what=NONE
fi

echo "check_keepalived=$what"
