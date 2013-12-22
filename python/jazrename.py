# For the old functional data for the LDProj, I pulled the images off a
# Jaz drive, but mri_convert couldn't handle the original naming of the
# files (e.g. I.001.s01, I.001.s02, ...), so I'm changing them to just
# I.001, I.002, ..., I.7999, I.8000

import sys, math
for line in sys.stdin:
    ind1 = line[2:5]
    ind2 = line[7:]
    new_ind = 20*int(ind1) - (20 - int(ind2))
    if len(str(new_ind)) == 1:
        new_ind = '000' + str(new_ind)
    if len(str(new_ind)) == 2:
        new_ind = '00' + str(new_ind)
    if len(str(new_ind)) == 3:
        new_ind = '0' + str(new_ind)

    new_file = line[0:2] + str(new_ind)
    print "cp", line.strip(), "new_func/" + new_file
