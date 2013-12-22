# dir.py
# usage: python dir.py < list.txt
# Used for making directories and copying files. This was
# done on /thalamus/mirror/cerebellum, to get the data for
# the NIHPD study in a decent directory structure.

import sys
for line in sys.stdin:
   lst = line.split('/')
   destdir = '/'.join(lst[-2:])
   datestring = '-'.join(lst[8:11])
   print "mkdir -p", datestring + '/' + lst[-2]
   print "cp -R ", line[:-1], datestring + '/' + destdir
