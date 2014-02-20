#!/bin/bash

DIR=../images/20110913_nederlands #Directory currently holding pictures
TARGET=$DIR	# URL prefixes
HEIGHT=140	#set the height for each picture to have
COMPRESS="/usr/bin/convert -auto-orient -thumbnail x"$HEIGHT" -compress none -quality 50"	# Compression command
DIR_COMP=$DIR/pic_comp	# Dummy dir for compressed images
MAX_PER_PAGE=200

PAGE="1"
N="1"

rm $TARGET*.html
rm -f $DIR_COMP/*
mkdir $DIR_COMP

for i in `ls $DIR`
do
	if [ $N -lt $MAX_PER_PAGE ] 
	  then echo fin 	
		$COMPRESS $DIR/$i $DIR_COMP/$i.j #2>> /dev/null
   		echo "<a href=\"$DIR/$i\"><img src=\"$DIR_COMP/$i.j\" height=\"$HEIGHT\"></a>" >> $TARGET$PAGE.html
 	  else echo fin 2
		NEXT=$[$PAGE+1]
		echo "<a href=\"$TARGET$NEXT.html\">next</a>" >> $TARGET$PAGE.html
		PAGE=$NEXT
		N="0"
	fi
	echo fin3
	N=$[$N+1]
done
chmod -R 755 *