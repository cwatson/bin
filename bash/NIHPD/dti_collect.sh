#!/bin/bash
# Get the DTI and eDTI series and copy to a common directory; 
# these are NIHPD, objectives 1 and 2.
#
#_______________________________________________________________________________
# by Chris Watson 2008-04-09

DTI=/thalamus/mirror/cerebellum/dti.txt  #text file containing paths to DTI series.
EDTI=/thalamus/mirror/cerebellum/edti.txt  #text file containing paths to eDTI series.
MAIN=`pwd`

# Make sure we're in the correct directory.
#if [ `basename ${PWD}` != MR ]
#        then
#        echo "ERROR: You must be in the 'MR' directory."; exit
#fi

# Make sure arguments are given.
#if [[ $# -ne 3 ]]
#	then
#	echo "ERROR: Usage: dti_collect.sh year month day"; exit
#fi

# First, see if the scans exist for that date.
#if [ ! -e $1/$2/$3 ]
#	then
#	echo "Directory $1/$2/$3 does not exist."; exit
#fi

# See if there is more than one subject per scan date.
#ls $1/$2/$3 > tmp_sub.txt
#subjs=`wc -l tmp_sub.txt | awk '{print $1}'`
#if [[ $subjs -gt 1 ]]
#	then
#	echo "There are $subjs subjects for this date:"
#	cd $1/$2/$3
#	find . -name ".StudyDict" | xargs grep "PatientName"	#figure out their patientID
#	cd $MAIN
#fi

# Get the pathnames to the relevant directories.
for s in `ls -1d ./*/*/*/*`
do
	cd $s
	for d in `ls -1d ./*/*`
		do
		export image=`ls $d | awk 'NR == 1'`
		dti1=`dcmdump "$d/$image" | grep "\[DTI"`
		if [[ -n $dti1 ]] 
			then 
			echo `pwd`/$d >> $DTI
		fi
		dti2=`dcmdump "$d/$image" | grep " DTI"`
		if [[ -n $dti2 ]]
			then
			echo `pwd`/$d >> $DTI
		fi
		edti=`dcmdump "$d/$image" | grep "eDTI"`
		if [[ -n $edti ]]
			then
			echo `pwd`/$d >> $EDTI
		fi
	done
cd $MAIN
done
#rm tmp_sub.txt
