#! /bin/bash
# Get trials in which the controls_adolescents didn't respond.
# by Chris Watson 11/15/2007

SUBJDIR='/raid2/fmri5/cardiac/controls_adolescents'
SUBJS='elizabethm elizabeths emanuel ian jamie jocelyn jonathon kathryn michael rachel russell'

for s in $SUBJS
    do
        echo "$s" >> $SUBJDIR/no_responses.txt
        awk 'NR == 51 {print $0}' $SUBJDIR/$s/raw-data/visualclosure-*-results.txt >> \
        $SUBJDIR/no_responses.txt
        awk 'NR >= 52 && $3 == 0 {print $1,"\t\t",$2,"\t",$3,"\t\t",$4,"\t\t",$5,"\t",$6,"\t\t",$7}' \
        $SUBJDIR/$s/raw-data/visualclosure-*-results.txt >> \
        $SUBJDIR/no_responses.txt
        echo >> $SUBJDIR/no_responses.txt
    done
    
