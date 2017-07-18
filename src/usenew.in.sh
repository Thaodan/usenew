#\\include config.shh
#\\ifdef STATIC 
#\\macro <shpp.local/clear_comments.shpp>
#\\endif
#!/bin/@SHELL@

# wine prefix chooser and manager
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
USE_VER=@use_ver@

#\\ifndef STATIC
. ${LIBSH:-@prefix@/lib/libsh} 
#\\else
appname=${0##*/}
#\\   include ../libsh/src/d_msg.in.sh
#\\   include ../libsh/src/farray.in.sh
#\\   include ../libsh/src/test_input.in.sh
#\\   include libuse/base.in.sh
#\\endif

# settings
############################################ 

DMSG_ICON=wine  # icon for gui d_msg output
DMSG_DIALOG_DISABLED=true # we dont need dialog for cli so disable it
WDEBUG=fixme-all  # define wich wine debug out will shown in if $WINEDEBUG is not set
default_win_arch=win32 # define the default wine architecture
err_input_messages="no options given run $appname -h for help, or -H for long help:wrong options or only prefix given run $appname -h for help, or -H for long help" # err messages for test_input
export WINE_PREFIXES="$WINEPREFIX_PATH" # for winetricks

#\\ifdef USERRC 
. @USERRC@
#\\endif

#\\ifdef SYSTEMRC
. @SYSTEMRC@
#\\endif 
#############################################



u_help () { # display short help
d_msg 'help' "Usage: $appname wineprefix command/file options
supported files: *.exe;*.bat;*.cmd;*.reg;*.dll

  syntax: $appname [prefix] [command/file] [options]

type $appname -H for long-help"
}

u_long_help () { # display long help
d_msg 'help' "\
Usage: $appname wineprefix command/file options 
supported files: *.exe;*.bat;*.cmd;*.reg;*.dll 

  syntax: $appname [options] [prefix] [command/file] [start taget options] 
  

general options:
  -g	--gui			enable gui output
  -h	--help			show help
  -H	--long-help		show this text, long help
  -V	--version		show version
	--revision		show revision
  -v	--verbose		be more verbose
	--debug			help us in debuging
  
options:
  -b	--binpath <binpath>	define in wich path $appname will search for wine and CO
  -r    -run-debug		don't set WINEDEBUG to ${WDEBUG:='default $WINEDBUG not set'}  (\$WDEBUG)
  -d 	--desktop    		start file/command in virtual desktop 
  -D 	--directory  		tell $appname to change directory to started file
  -p    --prefix     		replacement for prefix, $appname will ask for prefix is this option is given ( usefull to start Windows programms out of file manager)
  commands:
    winefile open winefilebrowser
    winecfg  open winecontrol
    appconf  control the software of the chosen prefix
    control  open control
    cmd      open winecommandline
    open     open prefix directory with xdg-open

  file specific  options:

    *.bat/*.cmd file:
      -w, --window open file in new window

    *.reg file:
      -i import regefile
      -e export the given part of registry to file
	 syntax for export to regfile :
	 $appname [prefix] [regfilename.reg] -e [regpath]

ENVIRONMENT
    
    WINEPATH		
      set path where $appname searchs for wine
    WINEPREFIX_PATH
      path where $appname searchs for wineprefixs, default is \$HOME
"
}


# tools

u_create_prefix () {
  
    if d_msg f prefix "prefix $1 don't exist, create it?" ; then  # if prefix doesn't exist create one yes or no?
      if [ $(uname -m) = x86_64 ]; then
	 DMSG_XBUTTONS='win32:1,win64:0'
	 input=$(d_msg i 'prefix select' "Which Windows architecture the prefix should support please enter win64(64bits) or win32(32bits), default $default_win_arch")	 
	 case  "$input" in
	   win32) export WINEARCH=win32 ;;
	   win64) export WINEARCH=win64 ;;
	   *) d_msg 'prefix arch' "$default_win_arch used" ; export WINEARCH=$default_win_arch ;;
	 esac
      fi
    else
      return 1
    fi

}

skip_run() {
  while [ ! $# -eq 0 ] ; do
    run_int=$(echo $run_int | sed "s/$1//")
    shift
  done
}

add_run() {
  while [ $# -gt 0 ] ; do
    run_int=$run_int:$1
    shift
  done
}

if [ ! -t 1 ] ; then # test if is usenew runned outside from terminal and use DMSG_GUI=true to get gui output from d_msg if outsite of terminal
  DMSG_GUI=1
fi

if [ ! $# = 0  ] ; then
  ext=1
  while test "$ext" != "" # main loop
    do	
	posixly=$POSIXLY_CORRECT
	export POSIXLY_CORRECT=1 # set POSIXLY_CORRECT to true cause we want that getopt stops after first non option  input to prevent that it parses the arguments of $runed_exe
	run_int=set_wine_db
	u_optspec=rb:dphHvVg #-: # short options
	u_optspec_long=run-debug,binpath:,desktop,prefix,help,long-help,verbose,debug,revision,gui,version # long options
	PROCESSED_OPTSPEC=$( getopt -o $u_optspec --long $u_optspec_long \
	-n "$appname"  -- "$@")  || d_msg ! error  "$( read_farray "$err_input_messages" 2 )" || exit 1 # parsed optspec
	eval set -- "$PROCESSED_OPTSPEC"
	export POSIXLY_CORRECT=$posixly
	unset posixly
	while [ ! $# = 0 ] ; do # TODO: improve this with getopt
	  case "$1" in
	    -h|--help) u_help ; shift ;;
	    --long-help|-H|-HL) u_long_help ; shift ;;
	    --debug) 
	      set -o verbose
	      set -o xtrace
	      shift
	      continue
	      ;;
	    -v|--verbose) set -o verbose  ; shift ; continue ;;
	    -V|--version) 	d_msg version "$USE_VER" ; shift ;;
	    -g|--gui) 	DMSG_GUI=1 ; shift ; continue ;; # display msg in gui
	    -b|--binpath)
		# set which wine version usenew should use
                # just set WINEPATH, libuse wil do the job afterwards
                WINEPATH="$2"
                shift 2 ;;

            -d|--desktop) 
		  eval last_argument=\$$#
		  argument_d="${last_argument##*/}"
		  wine_args="explorer /desktop=$(echo $argument_d | sed -e 's/.exe//g' -e 's/ //g'),800x600"
		  shift ;; 
		-p|--prefix) 
		  eval last_argument=\$$#
		  file="${last_argument##*/}"
		  prefix="$(d_msg i 'enter prefix' "Please enter prefix to start $file")" \
		      || exit 1
		  shift
		;;
		--) shift; break ;; # if [ $1 =  -- ] ; then no more options in input  
	  esac
	done
	if [ $# = 0 ] ; then 
	  true
	elif test_input "$@" "$prefix"  ; then 
#\\ifndef STATIC
	    shload libuse/base
#\\endif
	    usenew_old_ifs=$IFS
	    IFS=:
	    for run_i in $run_int ; do
		IFS=$usenew_old_ifs
		$run_i
		IFS=:
	    done
	    IFS=$usenew_old_ifs
	    if [ -z "$prefix" ] ; then
		prefix="$1"
		shift
	    fi
	    IFS=$usenew_old_ifs
	    unset IFS
	    if check_prefix "$prefix" || u_create_prefix "$prefix"   ; then
		prefix ${WINEPREFIX_PATH:-$HOME/.}/"$prefix"
	    else
		exit 1
	    fi
	    
	    runed_exe="$1"
	    shift  # shift $+1 to remove $1 from $@ that arguments go collected to started program # maybe replace file type detection by extension with detection through mime-type
	    case "$runed_exe" in # detect wich file or options given
		*.EXE|*.exe|*.bin)	"${WINE:-wine}"$cmd $wine_args "$runed_exe" "$@" ;; # exec executable file
		*.dll|*.ax)  "${WINE:-wine}" regsvr32.exe "$@" ;;
		*.bat|*.BAT]|*.cmd|*.CMD) # exec bat/cmd file
		    case $runed_exe in
			-w|--window)  "${WINE:-wine}" wineconsole.exe --backend=user cmd.exe "$1" "$2"  "$3" ;; # if option -w (--window) start file in new window
			*)  "${WINE:-wine}" cmd.exe /c "$runed_exe" "$@" ;;
		    esac
		    ;;
		*.reg) # import regfile into prefix
		    case $1 in
			-e) "${WINE:-wine}" regedit.exe /e "$runed_exe" "$2" ;;
			-i) "${WINE:-wine}" regedit.exe "$runed_exe"    ;;
			*)  d_msg ! faile 'no option for import(-i) or export (-e) given' ;;
		    esac
		    ;;
		*.msi) "${WINE:-wine}" msiexec.exe /i "$runed_exe" "$@" ;;
		# built in commands
		##############
		appconf|uninstaller)  "${WINE:-wine}" $wine_args uninstaller.exe "$@" ;;
		cmd)      "${WINE:-wine}" $wine_args cmd.exe "$@" ;; #console --backend=curses
		control)  "${WINE:-wine}" $wine_args control.exe "$@" ;;
                open)  
		    if echo  "$1" | grep -q '[Aa-Zz]:' ; then
			windir="$( winepath -u "$1" )"
			if [ "$windir" ]  ; then
			    xdg-open "$windir"
			else
			    d_msg ! 'Not Found' 'No such directory'
			fi    
		    else
			xdg-open "$WINEPREFIX"/"$1"  
		    fi
		    ;;
                delete)
                    if d_msg ! "Delete Prefix" "Really delete this prefix?" || [ "$1" = "-f" ] ; then
                        rm -rf "$WINEPREFIX";
                    fi
                    ;;
		*) command "${runed_exe}" "$@"  ;; #we use exec cause its safer cause "$runed_exe" cant be a internal function
	    esac
	else
	  false
	fi
	error_status=$? 
    ext=
  done
else
  read_farray "$err_input_messages" 1 >&2
  false
fi
exit $error_status
