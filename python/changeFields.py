#! /usr/bin/python

def main():
    """
    Given a csv file (exported from an excel sheet), this file will take a
    column of subject names (e.g. "Chris Watson") and will turn it into two
    columns (e.g. "Watson","Chris").
    """

    f = raw_input("Enter filename: ")
    c = raw_input("Enter column #: ")
    f_in = open(f,'r')
    fout = open('out.txt','w')

    for line in f_in:
        fields = line.split(',')

        name = fields[int(c)-1].split(' ')
        lastname = name[0]
        firstname = name[1]

        fout.write('"%s,%s"\n' % (lastname,firstname))

if __name__ == "__main__":
    main()
