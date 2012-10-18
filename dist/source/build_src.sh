 #!/bin/sh -e

# build src to build 
SOURCE_PATH=src

#### Config ###

if [ ! -e $SOURCE_PATH ] ; then 
  cd ../.. # cd to source dir
fi
. $PWD/src/sh_makefile


. $PWD/PROJECT_INFO




BUILD_FILE=$PROJECT_NAME-$VER${ARCHIVE_ENDING} # use projekt $VER when build src archive 
######################
### excute part ###

mkdir $BUILD_FOLDER
sh -c ". $PWD/$SOURCE_DIST/source_clean"
sh -c "cd $DIST_DIR; . \$PWD/dist_clean"
# only list  directorys and files that are in root to copy them in to $BUILD_TMP and exclude backups (files with ~ at the end) #  -e 's/^.//' -e  's/^\///'
for DIST_FILE in $DIST_FILES ; do  
  if [ -d $DIST_FILE ] ; then
    for file in $( find $DIST_FILE ! -iname '*~' ! -name  '*.tar.*' ! -name 'dist/pacman/{src,pkg}' | sed -e '1 d' -e 's/^.\///') ; do 
      mkdir -p $BUILD_FOLDER/$( dirname $file ); 
      if [ ! -d $file ] ; then
	cp $file $BUILD_FOLDER/$file ;
      fi 
    done
  else
    cp $DIST_FILE $BUILD_FOLDER/.
  fi

done
# cd $BUILD_TMP
# clean uneeeded archives in our source dist
# rm -rf dist/pacman/*.tar.xz
# rm -rf dist/pacman/{pkg,src}
# rm -rf dist/source/*$ARCHIVE_ENDING
# rm -rf dist/source/${PROJECT_NAME}_latest # remove link to latest archive too
# rm -rf ${PROJECT_NAME}_latest$ARCHIVE_ENDING
# rm -rf build_src.sh
tar -caf $SOURCE_DIST/$BUILD_FILE $BUILD_FOLDER
#mv $BUILD_FILE ../$SOURCE_DIST/$BUILD_FILE
#cd .. # go back to source dir
rm -rf $BUILD_FOLDER

rm -rf $SOURCE_DIST/${PROJECT_NAME}_latest

ln -s $BUILD_FILE $SOURCE_DIST/${PROJECT_NAME}_latest$ARCHIVE_ENDING # link to latest source
ln -s $PWD/$SOURCE_DIST/${PROJECT_NAME}_latest$ARCHIVE_ENDING ${PROJECT_NAME}_latest$ARCHIVE_ENDING # same but now in $PROJECT_NAME root
