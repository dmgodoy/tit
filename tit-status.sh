#!/bin/bash
set -f #disable glob for '*'
cmd="find -type f"
for i in $(cat .titignore); do cmd="$cmd -not -path \"$i\"" ; done;

eval $cmd
