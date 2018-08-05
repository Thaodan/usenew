#!/bin/sh
#\\include ../config.shh
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
 
LIBUSE_BACKUP_VER=1.1
LIBUSE_VER=@LIBUSE_VER@

### functions for collect and restore data

backup_data () { # backup application data
#########################################
# user_data         = path of user files for the  application
# backup_option     = sub-directory that is backupt by backup_data
# backup_compressor = set compressor to tar archive with backup (default @LIBUSE_BACKUP_DCOMPRESSOR@)
#########################################

  local dir
  # look if there's any file inside "$user_data/$backup_option"
  for file in "$user_data/$backup_option/"* ; do
      break
  done

  if [ ! -e "$file" ]; then
      # if dir is empty return without error
      return 0
  fi

  dt=$(date +%d_%m_%Y_%H_%M)
  mkdir -p "$user_data/backups"

  cat > "$user_data/backups/$dt"/source.info <<END
BACKUPED_APPNAME="$APPNAME"
ecopy_from='$user_data' 
backup_time_date=$(date +%Y.%H.%M)
backup_time=$(date +%d:%)
compressor=${backup_compressor:-xz}
BACKUP_APPVER=$LIBUSE_BACKUP_VER
BACKUP_APPNAME=libuse_back
END
  tar -caf "$appname.$dt.tar.xz" "$user_data/$backup_option"
}

restore_backup () { # restore backup archive that is made by backup_data
    if [ ! -z $# ] && [ -f "$1" ] ; then
        if ! tar -tf "$1" source.info ; then    
            d_msg ! 'Corupt file' "input file has no source.info (no restore backup archive or file broken?)"
            return 1
        fi
      temp=$( mktemp -d)
      tar --directory=$temp -xaf "$1" && \ 
      local source_file=$temp/*/source.info # search for source.info in  "$1", if no source.info found ; then display error. $temp/$( $temp)/source.infayyaY
      if bash -n $source_file ; then
	  source $source_file
      fi
#\\ifndef wOLDBACKUP 
#\\warning "wOLDBACKUP is depreacted"
      if [ -z $BACKUP_APPVER ] ; then
	  #FIXME put this in a seperate file
	 # d_msg ! 'Incompatible File' 'File is incompatible with this version of libuse/backup($LIBUSE_VER)'
	  # ask before overite target with backup if answer is no return with 1 ( d_msg returns 1 if answer is no)
	  d_msg f overrwrite  "Realy overrwrite  ${BACKUPED_APPNAME:-${1##*/}} data from $(echo ${backup_time[0]} at ${backup_time[1]:-"not set"} | sed 's/_/./g') with $copy_from?" &&  \
	      tar --directory="$copy_from" -axf "$1"
	  rm -rf $temp
      else
#\\endif
	  d_msg f Overwrite Realy overite "${BACKUPED_APPNAME:-${1##*/}}  data from $backup_time at $backup_time_date"
#\\ifndef wOLDBACKUP
      fi
#\\endif
  else
	  d_msg ! faile  'Input not exist  or is no file' 
      
  fi
  return $?
}
