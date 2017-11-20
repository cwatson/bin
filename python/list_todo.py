#! /usr/bin/python
# List the TODO's in TODO.org

import sys
from colorama import init, Fore, Back, Style
init(autoreset=True)

def main():
    """
    List the headings and the TODO's in a TODO.org file.

    USAGE:
    python list_todo.py TODO.org
    """

    todofile = open(sys.argv[1], 'rb')

    line_iter = iter(todofile)
    for line in line_iter:
        if line[0:2] == '* ':
            print(Fore.MAGENTA + Style.BRIGHT + line.strip())

        if 'TODO' in line:
            print(Fore.RED + Style.BRIGHT + line.strip())
            if line.find(']') == -1:
                continue

            total = line[(line.find('/')+1):line.find(']')]
            done = line[(line.find('[')+1):line.find('/')]
            n = int(total) - int(done)
            for i in range(n):
                print todofile.next().strip()

if __name__ == "__main__":
    main()
