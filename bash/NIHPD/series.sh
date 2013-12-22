#!/bin/bash
# Dumps the series names for all subjects into a text file.
# by Chris Watson 2008-04-17

MAIN=/thalamus/mirror/cerebellum/dti_scans/DTI

for acq in `find . -name "*.ACQ"`
do
	export image=`ls $acq | head -1`
	echo $acq >> series.txt
	dcmdump +P SeriesDescription $acq/$image >> series.txt
	echo >> series.txt
	echo "-----------------------" >> series.txt
	echo >> series.txt
done
