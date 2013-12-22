#! /usr/bin/python

def main():
    """
    Given a csv file (exported from an excel sheet), this file will write in
    a group name (class in Freesurfer FSGD files) based on other columns.

    e.g. if group=1, gender=1, location=1, it will output ControlMaleCHB
    """

    f = raw_input("Enter filename: ")
    f_in = open(f,'r')
    fout = open('out.txt','w')

    for line in f_in:
        fields = line.split(',')

        if fields[2] == '1':
            if fields[3] == '1':
                classname = 'TOFMaleCHB'
            else:
                classname = 'TOFMaleBI'

        else:
            if fields[3] == '1':
                classname = 'TOFFemaleCHB'
            else:
                classname = 'TOFFemaleBI'


        fout.write('Input %s %s %s\n' % (fields[0],classname,fields[1]))

if __name__ == "__main__":
    main()
