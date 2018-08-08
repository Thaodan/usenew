#!/bin/sh
user_data=$PWD/testapp
backup_option=test_data


. "$PWD"/test_env_env
. @libdir@/libuse/backup




backup_data
