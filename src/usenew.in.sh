#\\rem #!/bin/sh
#\\rem load buildconfig where we define build options
#\\include config.shh
#\\rem  use dash as shebang if use_dash is defined
#\\ifdef use_dash
#!/bin/dash
#\\else
#!/bin/sh
#\\endif

# wine prefix chooser and manager
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
# variables
#  version vars:
############################################
USE_VER=@use_ver@
USE_REV=@git_rev@

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


. ${LIBSH:-@prefix@/lib/libsh} 

u_help () { # display short help
d_msg 'help' "`cat <<_HELP
Usage: $appname wineprefix command/file options
supported files: *.exe;*.bat;*.cmd;*.reg;*.dll

  syntax: $appname [prefix] [command/file] [options]

type $appname -H for long-help
_HELP`"
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
  -r    -run-debug		don't set WINEDEBUG to ${default_w_db:='default $WINEDBUG not set'}  (\$default_w_db)
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
      if [ `uname -m` = x86_64 ]; then
	 buttons='win32:1,win64:0'
	 case $DMSG_GUI in
	    1|true)	input=`d_msg i 'prefix select' "Which Windows architecture the prefix should support please enter win64(64bits) or win32(32bits), default $default_win_arch"`;;
	    *)
	      echo "Which Windows architecture the prefix should support please enter win64(64bits) or win32(32bits), default $default_win_arch"
	      read input
	      ;;
	 esac
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
    run_int=`echo $run_int | sed "s/$1//"`
    shift
  done
}

add_run() {
  while [ $# -gt 0 ] ; do
    run_int=$run_int:$1
    shift
  done
}


# main function

main () {
    shload libuse/base
    old_ifs=$IFS
    IFS=:
    for run_i in $run_int ; do
	IFS=$old_ifs
	$run_i
	IFS=:
    done

    if check_prefix "$1" || u_create_prefix "$1"   ; then
	prefix ${WINEPREFIX_PATH:-$HOME/.}/"$1"
    else
	return 1
    fi

    runed_exe="$2"
    shift 2 # shift $+1 to remove $1 from $@ that arguments go collected to started program # maybe replace file type detection by extension with detection through mime-type
    case "$runed_exe" in # detect wich file or options given
	*.EXE|*.exe|*.bin)	"${WINE:-wine}"$cmd $wine_args "$runed_exe" $@ ;; # exec executable file
	*.dll|*.ax) "$BINPATH"regsvr32 $@ ;;
	*.bat|*.BAT]|*.cmd|*.CMD) # exec bat/cmd file
           case $runed_exe in
	       -w|--window)  "$BINPATH"wineconsole --backend=user cmd.exe $1 $2  $3 ;; # if option -w (--window) start file in new window
	       *)  "${WINE:-wine}" cmd.exe /c "$runed_exe $@" ;;
	   esac
	   ;;
	   *.reg) # import regfile into prefix
	   case $1 in
	       -e)  "$BINPATH"regedit /e "$runed_exe" $2 ;;
	       -i)  "$BINPATH"regedit "$runed_exe"    ;;
	       *)  d_msg ! faile 'no option for import(-i) or export (-e) given' ;;
	   esac
	   ;;
	   *.msi) wine "$BINPATH"msiexec.exe /i "$runed_exe" "$@" ;;
# built in commands
  ##############
       appconf|uninstaller)  "$BINPATH"wine $wine_args uninstaller.exe $@ ;;
       cmd)      "${WINE:-wine}" $wine_args cmd.exe "$@" ;; #console --backend=curses
       control)  "${WINE:-wine}" $wine_args control.exe $@ ;;
       open)  
       if echo  "$1" | grep -q '[Aa-Zz]:' ; then
	   xdg-open "$( winepath -u "$1" )"
       else
	   xdg-open "$WINEPREFIX"/"$1"  
       fi
       ;;
       *) sh -c  "exec "$runed_exe" $@"  ;; #we use exec cause its safer cause "$runed_exe" cant be a internal function
  esac
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
	-n $appname  -- "$@")  || d_msg ! error  "$( read_farray "$err_input_messages" 2 )" || exit 1 # parsed optspec
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
	    --revision)	d_msg revision "$USE_REV" ; shift ;;
	    -V|--version) 	d_msg version "$USE_VER" ; shift ;;
	    -g|--gui) 	DMSG_GUI=1 ; shift ; continue ;; # display msg in gui	  	
		-r|--run-debug) skip_run set_wine_db ; shift ;; 
		-b|--binpath) 	import libuse.wine_misc ; set_wine_ver "$2" ; shift 2 ;;  # set which wine version usenew should use
		-d|--desktop) 	argument_d=$(echo eval echo \$$#);  wine_args="explorer /desktop=$( basename $( $argument_d ) | sed 's/.exe//g'),800x600" ; unset argument_d ;shift ;; 
		-p|--prefix) 
		  argument_p=$( echo eval echo \$$# )
		  argument_p=$( $argument_p )
		  file=`basename $argument_p`
		  case $DMSG_GUI in
		    1|true) prefix="`d_msg i 'enter prefix' "Please enter prefix to start $file"`";;
		    *)
		      echo "Please enter prefix to start $file"
		      read prefix
		      test ! -z $prefix 
		      ;;
		  esac  || exit 1 
		  unset argument_p file
		  shift
		;;
		--) shift; break ;; # if [ $1 =  -- ] ; then no more options in input  
	  esac
	done
	if [ $# = 0 ] ; then 
	  true
	elif test_input $@ $prefix  ; then
	  IFS=$old_ifs
	  main $prefix $@
	  # 	    old_ifs=$IFS
	  # 	    IFS=:
	  # 	    for run_i in $run_int_p ; do
	  # 	      IFS=$old_ifs
	  # 	      $run_i
	  # 	      IFS=:
	  #	    done
	else
	  false
	fi
	error_status=$? 
    ext=
  done
else
  echo $(read_farray "$err_input_messages" 1) 
  false
fi
exit $error_status
