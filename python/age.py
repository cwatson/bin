#! /usr/bin/python

def main():
    """
    Compute ages.

    Given a csv file (exported from an excel spreadsheet), this file computes
    the age of subjects. The date of birth must be the 3rd column, and scan date
    must be the 6th column. The separation between columns is a ",". If your sheet 
    is different, it's an easy substitution.
    
    The dates must be formatted like so:
    MM/DD/YY
    """

    f = raw_input("Enter filename: ")
    f_in = open(f,'r')
    fout = open('ages.txt','w')
    for line in f_in:
        fields = line.split(',')
        
        if fields[6] == '"n/a"':
            # Means that the subj wasn't scanned.
            fout.write('"n/a"\n')
        else:
            birth = fields[2].split('/')
            scan = fields[5].split('/')

            birthmonth = int(birth[0])
            birthday = int(birth[1])
            birthyear = int(birth[2])

            scanmonth = int(scan[0])
            scanday = int(scan[1])
            scanyear = int(scan[2]) + 100

            if birthmonth > scanmonth:
                months = 12 - (birthmonth - scanmonth)
                years = scanyear - birthyear - 1
            else:
                months = scanmonth - birthmonth
                years = scanyear - birthyear


            fout.write('%0.4f\n' % (years + (months/12.0)))

if __name__ == "__main__":
    main()
