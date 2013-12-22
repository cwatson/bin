#!/bin/bash
# Script for renaming all the P-files so that they show the
# voxel location in the filename.
# by Chris Watson, 05/14/2008

# Current directory should be /raid2/mirror/occipital/nihpd_PFILES
for pfile in `ls -d */*`
do
    suffix=`rdgehdr $pfile | grep "Series Description" | awk '{print $NF}'`
    echo $suffix
    mv $pfile $pfile.$suffix
done
