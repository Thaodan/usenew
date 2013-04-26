#!/bin/sh 
USE_REV=@git_rev@
 
prepare() { # init vars that will exported from wine to the shell
  userprofile=`${WINE:=wine} cmd.exe /c echo %userprofile%`
  appdata=` ${WINE:=wine} cmd.exe /c echo %APPDATA%`
  system_drive=` ${WINE:=wine} cmd.exe /c echo %systemdrive%`
  program_files=` ${WINE:=wine}  cmd.exe /c echo %programfiles%`
  winsysdir=` ${WINE:=wine} cmd.exe /c echo %winsysdir%`
  windir=` ${WINE:=wine} cmd.exe /c echo %windir%`
  windir=`winepath  -u $windir`
  winsysdir=`winepath -u $winsysdir`
  userprofile=`winepath -u $userprofile`
  appdata=`winepath -u $appdata`
  system_drive=`winepath -u  $system_drive`
  program_files=`winepath $program_files`
}

check_wineserver() {
   if ps ax | grep wineserver | grep -vq grep ; then
    if d_msg f 'other wineserver' "An other wineserver is running, kill him (any other procces that run on wineserver will killed too)?" ; then
	  pkill wineserver  #--uid $(id -ru)  
	  return 0
    else
      return $?
    fi
  fi
}
set_wine_ver () { # no comment

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
  export BINPATH="$1"/bin/
fi

WINE=$BINPATH/wine
}