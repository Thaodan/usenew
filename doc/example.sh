#!/bin/bash
APPNAME="Sid Meier's Railrods!" # set name of application 
APPPATH="/home/bidar/.civ/drive_c/Programme/Sid Meier's Railroads!" # set appdir
PREFIX=/home/bidar/.civ # set WINEPREFIX
commands_l=( game help end )
commands_s=( g    h     e )  
exe=( RailRoads.exe display_help kill_exe )
default_exe=$exe # set $exe if no input was given 
wine_args="explorer /desktop=Railroads,800x600"#tell exec_exe to use virtualdesk
WDEBUG=fixme+all # set WINEDEBUG
LIBUSEAPP_LVL=2 # set applvl
  
  . /usr/lib/libuse/libuse # load libuse
