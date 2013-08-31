#!/bin/bash
# backup functions of libuse
#
# Copyright (C) 2013  Björn Bidar
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
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
  dt=$(date +%d_%m_%Y_%H_%M)
  mkdir -p "$user_data/backups"
  if [ -d "$user_data/$backup_option" ] && [ ! -e "$user_data/$backup_option/*"  ] > /dev/null 2>&1 ; then # if dir is empty return without error
      return 0
  fi
  cat > "$user_data/backups/$dt"/source.info <<END
BACKUPED_APPNAME="$APPNAME"
copy_from='$user_data' 
backup_time=( `date +%d_%m` `date +%Y_%H_%M` )
compressor=xz
END
  tar -caf "$appname.$dt.tar.xz" "$user_data/$backup_option"
}

restore_backup () { # restore backup archive that is made by backup_data
  if [ ! -z $# ] && [ -e "$1" -a -f "$1" ] ; then
    temp=$( mktemp -d)
    tar --directory=$temp -xaf "$1" "$(tar -taf "$1" | grep source)"  && \ 
    . $temp/$(ls $temp)/source.info # search for source.info in  "$1", if no source.info found ; then display error 
    if [ ! $? = 0 ]; then
      d_msg ! 'corupt file' "input file has no source.info (no restore backup archive or file broken?)" 
      rm -rf $temp
      return 1
    fi
    # ask before overite target with backup if answer is no return with 1 ( d_msg returns 1 if answer is no)
    d_msg f overrwrite  "Realy overrwrite ${BACKUPED_APPNAME=`basename "$1"`} data from `echo ${backup_time[0]} at ${backup_time[1]:=(not set)} | sed 's/_/./g'` with $copy_from?" &&  \
	tar --directory="$copy_from" -axf "$1"
    rm -rf $temp
  else
      d_msg ! faile  'Input not exist  or is no file' 
  fi
  return $?
}
