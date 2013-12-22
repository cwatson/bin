#! /bin/bash
# Automatically add entries to the tkremind calendar.
# by Chris Watson, 2010-06-29

if [ $# -lt 3 ]
then
    echo "USAGE: schedule.sh [Day] [Month] [Message]"
    echo -e 'e.g.\n[cwatson@occipital ~]$ schedule.sh 9 July "Foo Bar @10a, 3T."\n'
    exit 1
fi

echo -e "REM\t${1}\t${2}\tMSG\t${3}"
echo -e "REM\t${1}\t${2}\tMSG\t${3}" >> ~/.reminders
