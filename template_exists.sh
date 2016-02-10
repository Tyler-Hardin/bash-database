#!/bin/bash

# Checks to see if template exists
# Exits with 10 file is okay but template doesn't exist
# v1.0
# Tyler Hardin

if [ $# != 2 ]; then
    echo "usage: `basename $0` template-file template-name"
    exit 1
fi

def_file=$1
./check.sh $def_file f r
ret=$?
if [ $ret ]; then
    if [ ! "`head -n 1 $def_file`" = "templateFile definition" ]; then
        echo "Error: not a valid template file"
        ret=1
    fi
fi
while [ ! $ret ]; do
    echo "Enter the template file name: "
    read def_file
    ./check.sh $def_file f r
    ret=$?
    if [ ! $ret ]; then
        continue
    fi
    if [ ! "`head -n 1 $def_file`" = "templateFile definition" ]; then
        echo "Error: not a valid template file"
        ret=1
        continue
    fi
done
result=`cut -d" " -f1 $def_file | grep "^$2\$"`
if [ "$result" = "" ]; then
    exit 10
elif [ "$result" = "$2" ]; then
    exit 0
else
    exit 1
fi
