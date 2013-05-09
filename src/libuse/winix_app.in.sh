#!/bin/sh
USE_REV=@git_rev@

if [ -z "$libsh_ver" ] ; then
  echo "libsh not imported"
  exit 1
fi

import libuse.wine_misc

find_wine () {
  if [ ! -z "$WINEPATH" ] ; then 
    set_wine_ver "$WINEPATH"
  elif need 'wine' ; then
	return $?
  else 
    return $?
  fi
}


set_dll_override() # taken from winetricks
{
	_mk_temp_dir
    _W_mode=$1
    case $_W_mode in
    *=*) return 1 ;;
    disabled)
        _W_mode="" ;;
    esac
    shift
    cat > "$temp"/override-dll.reg <<_EOF_
REGEDIT4

[HKEY_CURRENT_USER\Software\Wine\DllOverrides]
_EOF_
    while test "$1" != ""
    do
        case "$1" in
        comctl32)
           rm -rf "$windir"/winsxs/manifests/x86_microsoft.windows.common-controls_6595b64144ccf1df_6.0.2600.2982_none_deadbeef.manifest
           ;;
        esac

        # Note: if you want to override even DLLs loaded with an absolute path,
        # you need to add an asterisk:
        echo "\"*$1\"=\"$_W_mode\"" >> "$temp"/override-dll.reg
        #echo "\"$1\"=\"$_W_mode\"" >> "$W_TMP"/override-dll.reg

        shift
    done

    exec_exe regedit.exe "$temp"/override-dll.reg

    unset _W_mode
     _rm_temp_dir
}

link_user_data() {
  echo stub
  unix_appdir=${XDG_DATA_HOME:=$HOME/.local/share}/$appname
  ln -s	$unix_appdir $appdata/$win_appdir	# link user_data to windows user data
  ln -s	$unix_appdir/user.reg $PREFIX/user.reg  # link user_settings to prefix
  
}


link_system() {
  regedit $unix_appdir/settings.reg
  
  for u_dll in $unix_appdir/libs/*.dll ; do
    if [ -e $winsysdir/$u_dll ] ; then
      rm $winsysdir/$u_dll
    fi
    ln -s $unix_appdir/libs/$u_dll $winsysdir/$u_dll
  done && set_dll_override native,builtin `ls $unix_appdir/libs/*.dll`
}