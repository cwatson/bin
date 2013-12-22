#! /bin/bash
# Get patient ID and Patient Name
# by Chris Watson 11/14/2007

DIR=/raid2/mirror/occipital/nihpd_PFILES
LIST=`ls $DIR`

for d in $LIST
do
    cd $DIR/$d
    FILE=`ls`
    for f in $FILE
    do
        $DIR/rdgehdr $f | grep "...Patient Name: " >> $DIR/names.txt 
        echo "$d/$f" >> $DIR/names.txt
        echo >> $DIR/names.txt
    done
done

awk '$0 !~ /'.BOS.'/ && $0 !~ /'.DCC.'/ {print $0}' $DIR/names.txt >> $DIR/real_names.txt
grep -C1 "...FF Patient Name" $DIR/real_names.txt >> $DIR/final_names.txt
