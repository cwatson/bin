#!/bin/bash
# Useful commands for linking filenames etc.
# Currently for DTI
# by Chris Watson, 2009-11-16

for f in `find . -type f -regex "./[^A-Z].*/.*/b0-.*"` 
do 
    ff=`echo ${f} | sed s:^./::`
    name=`echo ${ff} | awk -F / '{print $1}'`
    series=`echo ${ff} | awk -F / '{print $2}'`
    i=`echo ${series} | awk -F - '{print $3}'`
    echo ln -s `pwd`/${ff} b0/`echo ${ff} | sed s:${name}/:${name}${i}-: | sed s:${series}/::`
done

for f in `find . -type f -regex "./[^A-Z].*/.*/FA.*"` 
do 
    ff=`echo ${f} | sed s:^./::`
    name=`echo ${ff} | awk -F / '{print $1}'`
    series=`echo ${ff} | awk -F / '{print $2}'`
    i=`echo ${series} | awk -F - '{print $3}'`
    echo ln -s `pwd`/${ff} fa/`echo ${ff} | sed s:${name}/:${name}${i}-: | sed s:${series}/::`
done
