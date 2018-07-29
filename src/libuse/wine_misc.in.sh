#\\include ../config.shh
#!/bin/sh 
# part of libuse to bring the functionality to use an other wine version than the system installed 
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
 
check_wineserver() {
    wineserver_pid=$(pgrep wineserver)
    if [ ! "$wineserver_pid" = "" ] ; then
        # first check if wineserver is our wineserver
        if [ ! "$(cat "/proc/$wineserver_pid/cmdline" )" = "$BINPATH"/wineserver ] ; then
            if d_msg f 'other wineserver' \
                     "An other wineserver is running, kill him (any other procces that run on wineserver will killed too)?"
            then
                wineboot --end-session
            else
               return $?
           fi
        fi
    fi
}
set_wine_ver () {

    if [ -z "$1" ] ; then # unset wine version
        export LD_LIBRARY_PATH=
        export WINESERVER=
        export WINELOADER=
        export WINEDLLPATH=
        export BINPATH=
    else  # use wine version from path given by "$1"
        export LD_LIBRARY_PATH="$1"/lib:$LD_LIBRARY_PATH
        export WINSERVER="$1"/bin/wineserver
        export WINELOADER="$1"/bin/wine
        export WINEDLLPATH="$1"/lib/wine
        export BINPATH="$1"/bin
    fi
    
    WINE=$BINPATH/wine
}
