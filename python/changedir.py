# argument 1 is a text file that says something like:
# "mv old\ dir"
#
# argument 2 is a text file that says something like:
# "old_dir"
# 
# So this will print out:
# "mv old\ dir old_dir"
#
# Then you just pipe the output to bash and voila.
#______________________________________________________
# by Chris Watson 2009-11-17

import sys, getopt

f1 = open(sys.argv[1],'rb')
lines1 = f1.readlines()

f2 = open(sys.argv[2],'rb')
lines2 = f2.readlines()

for i in range(0,179):
    print lines1[i].strip(), lines2[i]
