#! /usr/bin/python
# List the TODO's in TODO.org

import sys, argparse
import re
from datetime import datetime
from datetime import timedelta
from colorama import init, Fore, Back, Style
init(autoreset=True)

today = datetime.now()
today = today.replace(hour=0, minute=0, second=0, microsecond=0)

def compare_dates(l, duedate, duedate_dt, nondate):
    """Compare the duedate in the line with today's date.

    Returns the input list (the final list of strings) appended with the present line.
    """
    if duedate_dt < today:
        l.append(Back.RED + Fore.WHITE + Style.BRIGHT + duedate + Style.NORMAL + nondate)
    elif duedate_dt == today:
        l.append(Fore.MAGENTA + Style.BRIGHT + duedate + Back.YELLOW + Fore.WHITE + Style.BRIGHT +
                 Fore.BLACK + Style.NORMAL + nondate)
    elif today < duedate_dt <= today + timedelta(days=7):
        l.append(Fore.MAGENTA + Style.BRIGHT + duedate + Back.GREEN + Fore.WHITE + Style.BRIGHT +
                 Fore.BLACK + Style.NORMAL + nondate)
    else:
        l.append(Fore.MAGENTA + Style.BRIGHT + duedate +
                 Fore.WHITE + Style.NORMAL + nondate)

    return l

def to_datetime(line):
    duedate = line[(line.find('<')):(line.find('>')+1)]
    duedate_dt = datetime.strptime(duedate[1:(len(duedate) - 1)], '%Y-%m-%d %a')
    return duedate, duedate_dt

def listDates(mytodo):
    """Returns a sorted (by date) list of strings."""
    l = []; d = []
    with open(mytodo, 'rb') as todofile:
        line_iter = iter(todofile)
        for line in line_iter:
            if line.find('<201') != -1 & line.find('DONE') == -1 & line.find('CANCELED') == -1:
                duedate, duedate_dt = to_datetime(line)

                if 'TODO' in line or 'STARTED' in line:
                    d.append(duedate_dt)
                    nondate = line[(line.find(' ', line.find(' ') + 1)+1):(line.find('<') - 1)]
                elif line.find('[X]') == -1:
                    d.append(duedate_dt)
                    nondate = line[(line.find(']') + 1):(line.find('<') - 1)]
                else:
                    nondate = False

                if nondate != False:
                    duedate = duedate + ' '
                    l = compare_dates(l, duedate, duedate_dt, nondate)

    l_sorted = [x for _,x in sorted(zip(d, l))]
    return l_sorted

def listAll(mytodo):
    """Return a list of strings containing TODO's and dates."""
    l = []
    with open(mytodo, 'rb') as todofile:
        line_iter = iter(todofile)
        for line in line_iter:
            if line[0:2] == '* ':
                l.append(Fore.MAGENTA + Style.BRIGHT + line.strip())
            elif line[0:4] == '*** ' and 'TODO' in line:
                l.append(Fore.CYAN + Style.BRIGHT + line.strip())
            elif line[0:4] == '****' and 'TODO' in line:
                l.append(Fore.YELLOW + Style.BRIGHT + line.strip())
            elif 'TODO' in line:
                l.append(Fore.RED + Style.BRIGHT + line.strip())

            elif line.find('[X]') == -1:
                if line.find('<201') != -1 & line.find('DONE') == -1:
                    duedate, duedate_dt = to_datetime(line)
                    l = compare_dates(l, duedate, duedate_dt, nondate)
                elif line.find('[ ]') != -1 & line.find('TODO') == -1 & line.find('DONE') == -1:
                    l.append(Fore.GREEN + line.strip())
                else:
                    continue

    return l

def print_header():
    print
    print(Fore.BLUE + Style.BRIGHT + 50*'#')
    print(Fore.MAGENTA + Style.BRIGHT + 'Color key:' + '\n')
    print('Red background:    ' + Back.RED + Fore.WHITE + Style.BRIGHT + 'Overdue!')
    print('Yellow background: ' + Back.YELLOW + Fore.BLACK + 'Due today!')
    print('Green background:  ' + Back.GREEN + Fore.BLACK + 'Due in the next 7 days!')
    print('Black background:  ' + 'Due later')
    print(Fore.BLUE + Style.BRIGHT + 50*'#')
    print(Fore.BLUE + Style.BRIGHT + 50*'#')
    print

def main():
    """
    Lists headings and (unfinished) TODO's in a org files. There are a few
    options for limiting the output:
        * List TODO's from a  single (top-level) category
        * List the category names
        * List TODO's with an associated due date
    """

    # Parse CLI arguments
    #---------------------------------------------------------------------------
    parser = argparse.ArgumentParser(description=main.__doc__,
            formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-c', '--category',
            action='store',
            default='all',
            help='Category name (default: %(default)s)',
            dest='category')
    parser.add_argument('-l', '--list',
            action='store_true',
            help='List the top-level categories and exit')
    parser.add_argument('-d', '--date',
            action='store_true',
            help='List items with a due date and exit')

    args = parser.parse_args()
    #---------------------------------------------------------------------------

    # Get list of org files from my vimrc
    myfile = open('/home/cwatson/.vimrc', 'r')
    for line in myfile:
        if re.search('org_agenda_files', line):
            myfiles = line

    myorg = myfiles.split('[')[1].split(', ')
    myorgs = [x[1:(x.find('.org')+4)] for _,x in enumerate(myorg)]
    base = [x.split('/')[len(x.split('/')) - 1] for _,x in enumerate(myorgs)]

    #-------------------------------------------------------
    # Command-line argument for dates only
    #-------------------------------------------------------
    if args.date:
        print_header()

        # Loop through the org files
        for f,b in zip(myorgs, base):
            print(Fore.CYAN + Style.BRIGHT + b)
            l = listDates(f)
            for x in l: print(x)
            print('\n' + Fore.BLUE + Style.BRIGHT + 25*'#' + '\n')

    #-------------------------------------------------------
    # All non-date arguments
    #-------------------------------------------------------
    else:
        l = listAll(args.file)
        if args.list:
            for x in l:
                if x.find('1m* ') != -1: print(x)
        else:
            category = args.category
            if category == 'all':
                for x in l: print(x)
            else:
                cat_ind = next((i for i, x in enumerate(l) if x.find(category) != -1))
                cat_ind2 = next((i for i, x in enumerate(l[(cat_ind + 1):len(l)]) if x.find('1m* ') != -1))
                for x in l[cat_ind:(cat_ind + cat_ind2 + 1)]: print(x)

    print

if __name__ == "__main__":
    main()
