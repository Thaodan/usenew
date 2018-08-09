# -*- sh -*-
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

backup_file="$(echo "$user_data"/backups/*)"
