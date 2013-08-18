#\\include config.shh
#!/bin/bash
# restore - part of libuse 
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
# variables
#  version vars:
############################################  
U_VER=0.6
U_REV=@git_rev@
err_input_messages='No input given'
DMSG_DIALOG_DISABLED=true 

. ${libdir:-@prefix@/lib}/libsh

if test_input $@ ; then
    while [ !  $# = 0 ]  ; do 
	case "$1" in 
	    -g|--gui) DMSG_GUI=1 ; shift ;;
	    --version|-V)  echo $U_VER:$U_REV; shift ;;
	    --revision) echo $U_REV ; shift ;;
	    --help|-h|-*) d_msg help "$appname usage: $appname [backup file]" ; shift ;;
	    --) shift; break ;;
	    *) 
	esac
    done
    if [ $# !=  0 ] ; then
	import libuse/backup 
	restore_backup "$1"
    fi
fi
