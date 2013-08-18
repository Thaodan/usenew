#\\ifndef STATIC
#!/bin/sh
# core functions of libuse
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
#\\endif
#\\rem if we have NYI stuff  enable stub
#\\ifdef NYI_STUFF_THERE 
stub() {
    echo stub
}

#\\endif

#\\ifndef STATIC
if [ -z "$libsh_ver" ] ; then
  . ${libdir:-@prefix@/lib}/libsh || exit
fi
#\\else
#\\include <libuse/wine_misc.in.sh>

#\\endif


### functions for that are only in use with wine

check_prefix () {  # check if  $1 is a prefix
  if ! ( [ -d "${WINEPREFIX_PATH:-$HOME/.}/$1" ] && [ -e "${WINEPREFIX_PATH:-$HOME/.}/$1/system.reg" ] ); then
      return 1
  fi  
} 




set_wine_db () { # set wine debug
  if [ -z $WINEDEBUG ]; then 
    export WINEDEBUG=${WDEBUG:=fixme-all}
  fi
}



exec_exe () { # start wine with $exe
  if [ ! -z "$1" ]; then
    runed_exe="$1"
    shift
    ext=1
    while test "$ext" != ""
      do
	"${WINE:-wine}" $wine_args "$runed_exe" $@ ; return_stat=$?
	ext=
    done
    return $return_stat
  fi
}

prefix () { # set prefix var
    export WINEPREFIX=${1:-${PREFIX:-$HOME/.wine}}
}




### base functions 

exec_cmd () {
  #BIN=wineconsole
  "${WINE:-wine}" cmd.exe /c "$1"
}



if [ ! -z "$WINEPATH" ]; then
#\\ifndef STATIC
    import libuse/wine_misc
#\\endif
    check_wineserver || exit 1
    set_wine_ver "$WINEPATH"	
fi
