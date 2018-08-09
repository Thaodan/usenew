#!/bin/sh

# shellcheck source=./backup_test_base
. "$PWD"/backup_test_base

found=t

for item in $(tar -taf "$backup_file" ) ; do
    if [ ! -e "$user_data/$backup_option/$item" ] ; then
        found=$item:$found
    fi
done 

if [ ! "$found" = t ] ; then
    d_msg ! 'test failed: archive' "following items are not found: $found"
    exit 1 
fi

cleanup
