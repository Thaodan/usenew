#!/bin/sh


USE_REV=@git_rev@


parse_input() {

    # load backup support if enabled
    if [ $backup ] && [ ! $backup =  [Ff]alse ] && [ $backup = 0 ] ; then
	import libuse.backup
    fi



    # add std options like --help, --version, --kill
    if [ $add_std_options ] &&  [ ! $add_std_options = [Ff]alse  ] &&  \
       [ ! $add_std_options = 0 ]  ; then

	
	LONG_OPTIONS=$LONGOPTIONS:@DEFAULT_STD_OPTIONS_LONG@
	SHORT_OPTIONS=$SHORTOPTIONS:@DEFAULT_STD_OPTIONS_SHORT@
	EXECS=$EXECS:@DEFAULT_STD_OPTIONS_EXEC@

    fi
	

	
    





}



display_help() {


stub




}
