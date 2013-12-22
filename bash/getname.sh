#!/bin/bash
# Tells you which scan type (SPGR, Dual Echo) and patient
# name each series is for the pep subjects. 
#
# by Chris Watson 11/01/2007

cd /raid1/pep2/DICOM
for dirs in `ls -1d ./p*/*/*`
	do
	export FILE=`ls $dirs | head -1`
	dcmdump $dirs/$FILE | grep "SPGR" >> series.txt
	dcmdump $dirs/$FILE | grep "DUAL ECHO" >> series.txt
	echo $dirs >> series.txt
done

for DIR in `ls -1d ./p*/*`
	do
	export SERIES=`ls $DIR | tr "\n" " " | awk '{print $1}'`;
	export FILE1=`ls $DIR/$SERIES | tr "\n" " " | awk '{print $1}'`;
	dcmdump $DIR/$SERIES/$FILE1 | grep "PatientsName" >> names.txt
	echo $DIR >> names.txt
done
