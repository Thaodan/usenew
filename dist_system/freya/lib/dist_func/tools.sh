init_stats(){
    if [ $USE_COLOR ] ; then # use only colored out if enabled and if output goes to the terminal
	# prefer terminal safe colored and bold text when tput is supported [ ! -t 1 ]  && 
	if tput setaf 0 > /dev/null 2>&1 ; then
		ALL_OFF="$(tput sgr0)"
		BOLD="$(tput bold)"
		BLUE="${BOLD}$(tput setaf 4)"
		GREEN="${BOLD}$(tput setaf 2)"
		RED="${BOLD}$(tput setaf 1)"
		YELLOW="${BOLD}$(tput setaf 3)"
	else
		ALL_OFF="\e[1;0m"
		BOLD="\e[1;1m"
		BLUE="${BOLD}\e[1;34m"
		GREEN="${BOLD}\e[1;32m"
		RED="${BOLD}\e[1;31m"
		YELLOW="${BOLD}\e[1;33m"
	fi
    fi

}







plain() {
	first="$1"
	shift
	echo "${ALL_OFF}${BOLD} $first:${ALL_OFF} "$@""
	unset first
}

msg() {
	first="$1"
	shift
	echo "${GREEN}==>${ALL_OFF}${BOLD} $first:${ALL_OFF} "$@"" 
	unset first
}

msg2() {
	echo "${BLUE} ->${ALL_OFF}${BOLD} $first:${ALL_OFF} "$@""
	unset first
}

warning() {
	first="$1"
	shift
	echo "${YELLOW}==${ALL_OFF}${BOLD} $first:${ALL_OFF} "$@"" >&2
	unset first
}

error() {
	first="$1"
	shift
	echo "${RED}==>${ALL_OFF}${BOLD} $first:${ALL_OFF} "$@"" >&2
	unset first
	return 1
} 

verbose() {
  if [ $verbose_output ] ; then
    warning $@
  fi
}

