#!/bin/sh
# core functions of usenew
# NOTE; libuse v3 for integration of win32 applications unix systems
# functions for managing wine programs and their data
#
# Copyright (C) 2012  Björn Bidar
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
# functions that were used from other sh-libs:
# d_msg - display messages and ask for input
#
# variables
# ver=3.0
# shared_dir=/usr/share/libuse_v3/
USE_REV=@git_rev@

. ${libdir:-@prefix@/lib}/libuse/base


if [ ! -z "$LIBUSE_BACKUP" ] ; then
    import libuse/libuse.backup
fi


if [ "$1" = app1 ] ; then
    LIBUSEAPP_LVL=2
fi
 
if [ "${LIBUSEAPP_LVL:=0}" -ge 1 ] ; then 
    set_wine_db
    prefix
    ${APPPATH:+cd} "$APPPATH"
    case $LIBUSEAPP_LVL in
	1)  exec_exe "$exe"
	    ;;
	2)  import libuse/libuse.input_old
	    input_check $@
	    ;;
    esac
fi
   


