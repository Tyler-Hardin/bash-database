#!/bin/bash

# Checks to see if a file exists and is usable.
# Tyler Hardin
# 2/8/13 ver 1.1

#Check command line args
if [ "$#" -le "1" ]; then
    echo "usage: `basename $0` file option+"
    exit 1
fi

file=$1

#Check if file exists
if [ ! -e "$file" ]; then
    echo "Error: $file does not exist"
    exit 2
fi

#Check requested permissions
while [ $# -gt 1 ]; do
    shift
    if [ ! -$1 "$file" ]; then
        echo "Error: $file does not have $1 permissions"
        exit 3
    fi
done
