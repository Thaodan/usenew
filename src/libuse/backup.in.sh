#!/bin/bash
USE_REV=@git_rev@

if [ -z "$libsh_ver" ] ; then
  . ${libdir:-@prefix@/lib}/libsh || exit
fi
 

 


### functions for collect and restore data

backup_data () { # backup application data
#########################################
# user_data     = path of user files for the  application
# backup_option = sub-directory that is backupt by backup_data
#########################################
  lastdir="$PWD"
  dt=`date +%d_%m_%Y_%H_%M`
  mkdir -p "$user_data/backups/$dt"
#   if [ -d "$user_data/$backup_option" ] ; then
#     cd "$user_data/$backup_option" # remove /$backup_option
#   else
    
  if [ -d "$user_data/$backup_option" ] && [ -z `ls` ] > /dev/null 2>&1 ; then # if dir is empty return without error
      return 0
  fi
  cat > "$user_data/backups/$dt"/source.info <<END
BACKUPED_APPNAME="$APPNAME"
copy_from='$user_data' 
backup_time=( `date +%d_%m` `date +%Y_%H_%M` )
compressor=xz
END
  cp -a "$user_data/$backup_option" "$user_data/backups/$dt"
  cd "$user_data/backups" && tar -caf "$appname.$dt.tar.xz" "$dt"
  rm -r "$dt"
  cd "$lastdir"
}

restore_backup () { # restore backup archive that is made by backup_data
  if [ ! -z $# ] && [ -e "$1" -a -f "$1" ] ; then
    temp=$( mktemp )
    tar --directory=$temp -xaf "$1" "`tar -taf "$1" | grep source`"  && \ 
    . $tmp/`ls $temp`/source.info # search for source.info in  "$1", if no source.info found ; then display error 
    if [ ! $? = 0 ]; then
      d_msg ! 'corupt file' "input file has no source.info (no restore backup archive or file broken?)" ; return 1
    fi
    d_msg f overrwrite  "Realy overrwrite ${BACKUPED_APPNAME=`basename "$1"`} data from `echo ${backup_time[0]} at ${backup_time[1]:=(not set)} | sed 's/_/./g'` with $copy_from?" &&  \
    tar --directory="$copy_from" -axf "$1" # ask before overite target with backup if answer is no return with 1 ( d_msg returns 1 if answer is no)
#     return_var=$?
#     if  [ $return_var = 0 ] > /dev/null 2>&1  ; then
#       cp -a . "$copy_from"
#     fi
#     rm -r /tmp/$id"$rd" 
    rm -rf $temp
  else
    d_msg ! faile  'Input not exist  or is no file' 
  fi
  return $?
}