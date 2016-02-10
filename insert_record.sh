#!/bin/bash
# Adds a record to a db
# 3/16/2013
# Tyler Hardin
#
# Assumes all state files are correctly formatted
# Assumes databases.txt is db list file

db=$1

if [ ! "$#" = "1" ]; then
    echo "usage: `basename $0` db-name"
    exit 1
fi

template_file=$(./find_template_file.sh)
if [ ! $? = 0 ]; then
    exit 1
fi

./database_exists.sh "$db.db" databases.txt
if [ ! $? = 0 ]; then
    echo "Error: database doesn't exist"
    exit 2
fi

template_name=$(grep "^$db " databases.txt | cut -f 2 -d " ")

./template_exists.sh "$template_file" "$template_name"
if [ ! $? = 0 ]; then
    echo "Error: template doesn't exist"
    exit 2
fi

template=$(grep "^$template_name " $template_file)
fields=$(echo "$template" | cut -d " " -f "2-")
num_fields=$(echo "$fields" | wc -w)

correct=1
while [ ! $correct = 0 ]; do
    echo "Enter values for $fields"
    read -r input
    num_entered=$(echo "$input" | wc -w)
    if [ ! $num_entered = $num_fields ]; then
        echo "Error: incorrect number of fields: ($num_entered)"
        correct=1
    else
        correct=0
    fi
done

echo "$input" >> "$db.db"
echo "Record added to \"$db\" database"
