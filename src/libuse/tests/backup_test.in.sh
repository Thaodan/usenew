#!/bin/sh
test_root=$PWD/testapp
user_data=$test_root
backup_option=test_data


. "$PWD"/test_env_env
. @libdir@/libuse/backup

mkdir -p "$user_data/$backup_option"
touch  "$user_data/$backup_option"/foo
touch  "$user_data/$backup_option"/bar


if ! backup_data ; then
    d_msg ! 'test failed' 'Test failed early'
    exit 1
fi

found=t

backup_file="$(echo "$user_data"/backups/*)"

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
