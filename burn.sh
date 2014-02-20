#!/bin/bash

# Primary Configuration
DIR=$1		#Directory holding mp3 files
WAV=1		#true if you want files converted to wav format first

# Secondary Configuration
WAVDIR=$DIR/../$DIR_wavs
LAME=/usr/bin/lame
CDRDAO=/usr/bin/cdrdao
MKISOFS=/usr/bin/mkisofs

echo -e "Generating audio TOC...\n"
echo "CD_ROM_XA" > audio.toc
for i in `ls $DIR`
do
	echo "Begin: $i"
	#convert the file to wav if necessary
	if [$WAV -eq 1]	
		$i = $(echo $i | cut -f1'.')
		$LAME --decode $i $WAVDIR/$i.wav
	fi
	
	echo "	
		TRACK AUDIO
		PREGAP 00:01:00
		AUDIOFILE $i
	" >> audio.toc	
done

echo -e "\nTesting audio TOC:"
$CDRDAO show-toc audio.toc
echo -e "\nBurning audio TOC..."
$CDRDAO write --multi audio.toc

echo -e "\nCreating data image for multisession audio..."
SES = $(/usr/bin/cdrdao msinfo | tail -1)
if [$WAV -eq 1]
	D=$WAVDIR
else
	D=$DIR
fi
$MKISOFS -o data.iso -C $SES  $D/*

echo -e "\nGenerating data TOC..."
echo "	CD_ROM_XA
	TRACK MODE2_FORM1
	DATAFILE data.iso
" > data.toc

echo -e "\nBurning data TOC..."
$CDRDAO write data.toc