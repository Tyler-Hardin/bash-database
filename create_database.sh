#!/bin/bash

# Create a database
# v1.0
# Tyler Hardin

db_file=databases.txt

if [ ! $# = "2" ]; then
    echo "usage: `basename $0` template-name db-name"
    exit 1
fi

./database_exists.sh "$2.db" $db_file
ret=$?
if [ $ret = 0 ]; then
    echo "Error: db exists"
    exit 1
# Note: see database_exists.sh for explaination of exit code 10
elif [ ! $ret -eq "10" ]; then
    exit 1
fi

template_file=`./find_template_file.sh`
if [ ! $? ]; then
    exit 1
fi

./template_exists.sh $template_file $1
ret=$?
if [ ! $ret = "0" ]; then
    echo "Error: template doesn't exist"
    exit 1
fi

touch "$2.db"
echo "$2 $1" >> $db_file
echo "Info: database \"$2\" using template \"$1\" created"
