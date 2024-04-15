#!/bin/bash
git-hash(){
    cat $1 | git hash-object --stdin
}
in-index(){
    egrep -q "^$1 " $2
}
hash_cmd="git-hash"
INDEX=".tit/index"
if [ "$1" = "" ]; then
    echo "Usage tit add <path-to-file>"
    exit 1
fi
if [ ! -d .tit ]; then
    echo "Not a tit repository"
    exit 1
fi

touch $INDEX
for f in $@; do
    #file does not exist and it is not in the index
    if [ ! -f $f ] && ! in-index $f $INDEX; then
	   echo "$f does not exists"
           exit 1
    fi
    #file exists but it is not in the index
    if ! in-index $f $INDEX; then
        hash=$($hash_cmd $f)
        echo $f $hash >> $INDEX 
        echo "Added $f $hash to $INDEX"
        exit 0
    fi
    #flie exists and it is already in the index
    if [ -f $f ] && in-index $f $INDEX; then
        hash=$($hash_cmd $f)
        old_hash=$(egrep "^$f " $INDEX | awk '{print $2}')
        if [ "$old_hash" = "$hash" ]; then
            echo "Nothing to do for $f"
            exit 0
        else
            sed -i "s/^$f .*$/$f $hash/g" $INDEX
            echo "Updated file $f in index: $old_hash => $hash"
            exit 0
        fi
    fi 
    
done
