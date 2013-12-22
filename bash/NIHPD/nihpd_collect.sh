#!/bin/bash
# Get the T2 and T1 series and copy to a common directory; these are NIHPD,
# objective 2; age under 24months.
# As arguments, give year, month, date of scan.
#
#_________________________________________________________________________
# by Chris Watson 2008-03-26

ANAT=/thalamus/mirror/cerebellum/t1w.txt  #text file containing paths to t1 series.
HRT2=/thalamus/mirror/cerebellum/det2.txt  #text file containing paths to dualecho series.
MAIN=`pwd`
DEST=/thalamus/mirror/cerebellum/obj2_scans/

# Make sure we're in the correct directory.
#if [ `basename $MAIN` != MR ]
#        then
#        echo "ERROR: You must be in the 'MR' directory."
#        exit
#fi

# Make sure arguments are given.
if [[ $# -ne 3 ]]
	then
	echo "ERROR: Usage: nihpd_collect.sh year month day"
	exit
fi

# First, see if the scans exist for that date.
if [ ! -e $1/$2/$3 ]
	then
	echo "Directory $1/$2/$3 does not exist."
	exit
fi

# See if there is more than one subject per scan date.
ls $1/$2/$3 > tmp_sub.txt
subjs=`wc -l tmp_sub.txt | awk '{print $1}'`
if [[ $subjs -gt 1 ]]
	then
	echo "There are $subjs subjects for this date:"
	cd $1/$2/$3
	find . -name ".StudyDict" | xargs grep "PatientName"	#figure out their patientID
	cd $MAIN
fi

# Get the pathnames to the relevant directories.
for s in `cat tmp_sub.txt`
do
	cd $1/$2/$3/$s
	for d in `ls -1d ./*/*`
		do
		export image=`ls $d | awk 'NR == 1'`
		T1W=`dcmdump "$d/$image" | grep "T1W"`
		if [[ -n $T1W ]] 
			then 
			echo `pwd`/$d >> $ANAT
		fi
		DET=`dcmdump "$d/$image" | grep "DUAL ECHO"`
		if [[ -n $DET ]]
			then
			echo `pwd`/$d >> $HRT2
		fi
		PDW=`dcmdump "$d/$image" | grep "PDW"`
		if [[ -n $PDW ]]
			then
			echo `pwd`/$d >> $HRT2
		fi
	done
cd $MAIN
done
rm tmp_sub.txt

