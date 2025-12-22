#!/usr/bin/env bash

if [ -d /etc/patching ]; then
        what="$(grep -o '[0-9]*' /etc/patching/patch_policy)"

fi

if [ ! -n "$what" ]; then
        what="none"
fi

echo "current_patch_policy=$what"
