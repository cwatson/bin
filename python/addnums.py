#! /usr/bin/python
# Helper script to add/subtract a certain number to a list of numbers,
# or a text file full of numbers (where the first field is a number).
import sys

def main():
    """
    This script will add or subtract a certain number to a list of numbers
    or a text file full of numbers (the 1st field should be a number.
    You can pipe the text of the file to the script, then redirect the output
    to a new file.

    USAGE: cat foo.txt | python addnums.py "-4000" -
    This will subtract 4000 from each number.
    """

    for line in sys.stdin:
        words = line.split('\t')
        words[0] = str(int(float(words[0])) + int(sys.argv[1]))
        lineout = '\t'.join(words)
        print lineout

if __name__ == "__main__":
    main()
