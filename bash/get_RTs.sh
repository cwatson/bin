#!/bin/bash
# Get response times (RTs) from the subjects in realsubs.
# Uses the 'visualclosure-*-results.txt' files generated by 'visualclosure_parse_log.py'.
# by Chris Watson 11/09/2007

DIR=`dirname $PWD`
SUBJS=`ls -d $DIR/*_?/`
OUTDIR="$DIR/responsetimes"

# First, get all RTs for all subjects and place into a file.

for s in $SUBJS
    do
    awk 'NR >= 52 {print $2,$3,$5,$6}' $DIR/$s/raw-data/vi*.txt >> \
    $OUTDIR/TOTAL_RTs.txt
done

# Next, separate control trials from task trials.
# Trials with stimulus ID starting 'CC' are controls.
# Remove trials in which RT = 0 (no response).

awk '/^C[0-9]+/ {print $2,$3,$4}' $OUTDIR/TOTAL_RTs.txt >> $OUTDIR/RTs_all.txt
rm $OUTDIR/TOTAL_RTs.txt
sed -i "/^0/d" $OUTDIR/RTs_all.txt

# Now split the data into: all; all_correct/incorrect; 1trial_all/correct/incorrect; etc. 

DATA=$OUTDIR/RTs_all.txt

awk '/True/ {print $1}' $DATA >> $OUTDIR/RTs_all_correct.txt
awk '/False/ {print $1}' $DATA >> $OUTDIR/RTs_all_incorrect.txt

awk '/1$/ {print $1,$2,$3}' $DATA >> $OUTDIR/RTs_1trial_all.txt
awk '/True/ {print $1}' $OUTDIR/RTs_1trial_all.txt >> $OUTDIR/RTs_1trial_correct.txt
awk '/False/ {print $1}' $OUTDIR/RTs_1trial_all.txt >> $OUTDIR/RTs_1trial_incorrect.txt

awk '/2$/ {print $1,$2,$3}' $DATA >> $OUTDIR/RTs_2trial_all.txt
awk '/True/ {print $1}' $OUTDIR/RTs_2trial_all.txt >> $OUTDIR/RTs_2trial_correct.txt
awk '/False/ {print $1}' $OUTDIR/RTs_2trial_all.txt >> $OUTDIR/RTs_2trial_incorrect.txt

awk '/3$/ {print $1,$2,$3}' $DATA >> $OUTDIR/RTs_3trial_all.txt
awk '/True/ {print $1}' $OUTDIR/RTs_3trial_all.txt >> $OUTDIR/RTs_3trial_correct.txt
awk '/False/ {print $1}' $OUTDIR/RTs_3trial_all.txt >> $OUTDIR/RTs_3trial_incorrect.txt

cat $DATA | awk '{print $1}' > $DATA
cat $OUTDIR/RTs_1trial_all.txt | awk '{print $1}' > $OUTDIR/RTs_1trial_all.txt
cat $OUTDIR/RTs_2trial_all.txt | awk '{print $1}' > $OUTDIR/RTs_2trial_all.txt
cat $OUTDIR/RTs_3trial_all.txt | awk '{print $1}' > $OUTDIR/RTs_3trial_all.txt

wc -l $OUTDIR/RT*
