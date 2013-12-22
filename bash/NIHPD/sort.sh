#!/bin/bash
# Sorts the dicom images in the cerebellum/data/incoming/<study> folders
# into each respective series.
#_______________________________________________________________________________
# by Chris Watson 2008-04-15

for image in `ls`
do
	LOCALIZER=`dcmdump $image | grep "LOCALIZER"`
	if [[ -n $LOCALIZER ]]
	then
		echo $image >> ./localizer.txt
	fi
	T1W=`dcmdump $image | grep "T1W"`
	if [[ -n $T1W ]]
	then
		echo $image >> ./t1w.txt
	fi
	T2W=`dcmdump $image | grep "T2"`
	if [[ -n $T2W ]]
	then
		echo $image >> ./t2w.txt
	fi
#	if [[ -n $RELAX ]]
#	then
#		echo $image >> ./relaxometry.txt
#	fi
#	SPGR=`dcmdump $image | grep "spgr"`
#	if [[ -n $SPGR ]]
#	then
#		echo $image >> ./spgr.txt
#	fi
#	MPGR=`dcmdump $image | grep "mpgr"`
#	if [[ -n $MPGR ]]
#	then
#		echo $image >> ./mpgr.txt
#	fi
done
