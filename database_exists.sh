#!/bin/bash

# Checks if a db exists
# Note: exit code of 10 specifically means everything is correct EXCEPT
# the db doesn't exist (used in create_database.sh)
# v1.0
# Tyler Hardin

if [ ! $# = 2 ]; then
    echo "usage: `basename $0` db-file db-list-file"
    exit 1
fi

if [ ! -e $2 ]; then
    touch $2
else
    ./check.sh $2 f r w
    if [ ! $? ]; then
        exit 1
    fi  
fi

db_name=`basename $1 .db`
result=`cut -d " " -f 1 $2 | grep "^$db_name\$"`
if [ "$result" = "" ]; then
    exit 10
elif [ "$result" = "$db_name" ]; then
    touch $1
    exit 0
else
    exit 1
fi
