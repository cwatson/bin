# Make directories for Jaz-recovered LDProj functional data.

import sys
for i in range(1,401):
    ind = i
    #if len(str(ind)) == 1:
    #    ind = '00' + str(ind)
    #if len(str(ind)) == 2:
    #    ind = '0' + str(ind)
    print "mkdir", "volume" + str(ind)
