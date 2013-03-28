#!/bin/bash  
#\\include config.shh
U_VER=0.5
U_REV=@git_rev@
err_input_messages='No input given'
DMSG_DIALOG_DISABLED=true 
#gui=1
. ${libdir:-@prefix@/lib}/libsh
#. $HOME/bin/libsh



if test_input $@ ; then
  while [ !  $# = 0 ]  ; do 
      case "$1" in 
	-g|--gui) DMSG_GUI=1 ; shift ;;
	--version|-V)  echo $U_VER:$U_REV;;
	--revision) echo $U_REV ;;
	--help|-h|-*) d_msg help "$appname usage: $appname [backup file]" ; shift ;;
	--) shift ; ; break ;;
	*) import libuse.backup ; restore_backup "$1"  ; shift ;;
      esac
  done
fi
