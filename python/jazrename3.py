import sys

for line in sys.stdin:
    ind = line.strip()[6:]
    if len(ind) == 1:
        ind = '00' + ind
    elif len(ind) == 2:
        ind = '0' + ind
    print "mv", line.strip() + "/image001.img", line.strip() + "/image" + ind + ".img"
    print "mv", line.strip() + "/image001.mat", line.strip() + "/image" + ind + ".mat"
    print "mv", line.strip() + "/image001.hdr", line.strip() + "/image" + ind + ".hdr"
