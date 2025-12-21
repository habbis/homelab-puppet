#!/usr/bin/env bash

what="$(grep -o '[0-9]*' /etc/patching/patch_policy)"

if [ ! -n "$what" ]; then
        what="none"
fi

echo "current_patch_policy=$what"
