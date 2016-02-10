#!/bin/bash

# Finds the file containing the templates
# v1.0
# Tyler Hardin

result=`grep -n "^templateFile definition$" * | grep ":1:" | \
    cut -d: -f1`
num_files=`echo "$result" | wc -w`
if [ "$num_files" -eq 1 ]; then
    ./check.sh $result r w
    if [ $? ]; then
        echo $result
    else
        exit 1
    fi
elif [ "$num_files" -gt 1 ]; then
    echo "Error: multiple template definition files found:"
    echo "$result"
    exit 1
else
    echo "templateFile definition" > "template.dat"
    echo "template.dat"
fi
