#!/bin/bash

hash_cmd="git hash-object"
INDEX=".tit/index"
if [ "$1" = "" ]; then
    echo "Usage tit add <path-to-file>"
fi

touch $INDEX
for f in $@; do
    if [ ! -f $f ] && ! grep -qFx $f .tit/index; then
	   echo "$f does not exists"
    fi ;
    if ! grep -qFx $f $INDEX; then
	   echo $f >> $INDEX 
    fi ;
    
done
