import sys, string

for line in sys.stdin:
    fileparts = line.split('/')
    imname = fileparts[2]
    curpath = string.join(fileparts[0:2],'/') + '/'
    if imname[2] == '0':
        imname = imname[0:2] + imname[3:]
        print "mv", line.strip(), curpath + imname
