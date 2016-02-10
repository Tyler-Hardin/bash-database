#!/bin/bash

# Adds a template to the template def file
# v1.0
# Tyler Hardin

if [ $# -le 1 ]; then
    echo "usage: `basename $0` name field+"
    exit 1
fi

def_file=`./find_template_file.sh`
if [ ! $? = 0 ]; then
    exit 2
fi

./template_exists.sh $def_file $1
ret=$?
if [ $ret = 0 ]; then
    echo "Error: template exists"
    exit 1
# See template_exists.sh about exit code 10
elif [ ! $ret = 10 ]; then
    exit 1
fi

echo "$1 $2 $3 $4 $5 $6 $7 $8 $9" | tr -s " " >> $def_file
echo "Info: template '$1' added to template definition file '$def_file'"

