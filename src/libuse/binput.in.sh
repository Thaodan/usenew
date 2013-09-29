#!/bin/bash
# input parse functions of libuse
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

 

LIBUSE_INPUT_REV=135
###############################################
# input_check()
# 	added parameter  support for $exe
#       (dont works full now)
###############################################


test_input () { # test if input is right 
  if [ -n "${U_TESTINPUT_MSGS[$#]}" ] ; then
    d_msg ! 'wrong input' "${U_TESTINPUT_MSGS[$#]}"
    if [ ! -n $# ]; then
      return ${#:=1}
    else
      return 
    fi
  fi
}


input_check () { # builtin input test 
###########################################
# commands_s  = short input options like -h
# commands_l  = long input options like --help
# exe         = names of file/commands that were runed
#		by input check for commands_s[l] entry like display_help for -h 
# FORCE_RUN   = force input_check to use $FORCE_RUN as interpreter 
#		( if not set input_check detects interpreter per `file -b $exe`
# default_exe   (optional) file that were runed if no input is given
# 		if not set $nw_input_msg were echoed
# FORCE_RUN_default force input_check to use $FORCE_RUN_default as interpreter for $default_exe
#  NINPUT_MSG 	sets message that input_check displays if $default_exe is not set and no input given
###########################################

    local run __runner
    local DMSG_DIALOG_DISABLED=true

    if [ ! ${#commands_s[*]} = ${#commands_l[*]} ] ; then
	echo "${#commands_s[*]} not = ${#commands_l[*]}"
	return $(( ${#commands_s[*]} + ${#commands_l[*]} ))
    else
	if [ $# = 0 ] ; then
	    if [ ! -z ${default_exe} ] ; then
		#     if [ "$1" = - ] ; then 
		#       d_msg ! input "${WINPUT_MSG:=Wrong input given}" || return 1
		#     fi
		if [ -z ${FORCE_RUN_default} ] ; then 
		    case "`file -b "${default_exe}"`" in
			"PE32 executable for MS Windows (GUI) Intel 80386 32-bit"| PE32\ executable\ *) __runner=exec_exe;;
			"PE32 executable for MS Windows (GUI) Intel 80386 32-bit Mono/.Net assembly") __runner=mono;; 
	  		"POSIX shell script text executable") __runner=sh ;;
			"Bourne-Again shell script text executable") __runner=bash;; 
		    esac
	         
		else
		    __runner=${FORCE_RUN_default}		    
		fi
		case "${default_exe}" in  
			*\ * )  $__runner ${default_exe%\ *} ${default_exe#*\ } ;;
			    *)  $__runner ${default_exe%\ *} ;;
		esac
	    else
	       echo "${NINPUT_MSG:-No input given}" >&2
	    fi
	else
	    for (( run=0; run < ${#commands_l[*]}; run++)) ; do
		if [ "$1" = --${commands_l[$run]} ] || [ $1 = -${commands_s[$run]} ] 
		then	
		    if [ -z ${FORCE_RUN[$run]} ] ; then 
			case "`file -b "${exe[$run]%\ *}"`" in
			    "PE32 executable for MS Windows (GUI) Intel 80386 32-bit"| PE32\ executable\ *) __runner=exec_exe;;
			    "PE32 executable for MS Windows (GUI) Intel 80386 32-bit Mono/.Net assembly") __runner=mono;; 
	  		    "POSIX shell script text executable") __runner=sh ;;
			    "Bourne-Again shell script text executable") __runner=bash;; 
			esac
		    else
			__runner=${FORCE_RUN[$run]}
		    fi		 
		    case "${exe[$run]}" in  
			*\ * ) $__runner ${exe[$run]%\ *} ${exe[$run]#*\ }  ;;
			    *) $__runner ${exe[$run]%\ *} ;;
		    esac
		    break
		fi	
	    done 
	fi
    fi
}




display_help () {
    local run
    if [ ! -z "$HELP_MSG" ] ; then
	cat << _EOF
$HELP_MSG
_EOF
    else
	for (( run=0; run < ${#commands_l[*]}; run++)) ; do
	    cat << _EOF # display an builtin help message if $help_mgs is empty
-${commands_s[$run]} --${commands_l[$run]} ${exe[$run]}
_EOF
	done
    fi
}


kill_exe () { # kill first *.exe of $exe 
  pkill ${exe##*/}
}
