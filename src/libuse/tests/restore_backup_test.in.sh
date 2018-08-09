#!/bin/sh
# shellcheck source=./backup_test_base
. "$PWD"/backup_test_base
mv "$user_data/$backup_option" "$test_root"/save_env
restore_backup "$backup_file"


found=t

for item in "$test_root"/save_env/*  ; do
    item=${item##*/}
    if [ ! -e "$user_data/$backup_option/$item" ] ; then
        found=$item:$found
    fi
done 

if [ ! "$found" = t ] ; then
    d_msg ! 'test failed: archive' "following items are not found: $found"
    exit 1 
fi

cleanup
