#!/bin/bash
# Removes record(s) from a db
# 3/16/2013
# Tyler Hardin
#
# Assumes all state files are correctly formatted
# Assumes databases.txt is db list file

if [ ! "$#" = "3" ]; then
    echo "usage: `basename $0` db-name f-name f-val"
    exit 1
fi

db=$1
name=$2
value=$3

template_file=$(./find_template_file.sh)
if [ ! $? = 0 ]; then
    exit 1
fi

./database_exists.sh "$db.db" databases.txt
if [ ! $? = 0 ]; then
    echo "Error: database doesn't exist"
    exit 2
fi

template_name=$(grep "^$db" databases.txt | cut -f 2 -d " ")

./template_exists.sh "$template_file" "$template_name"
if [ ! $? = 0 ]; then
    echo "Error: template doesn't exist"
    exit 2
fi

template=$(grep "^$template_name" $template_file)
fields=$(echo "$template" | cut -d " " -f "2-")
index=$(echo "$fields" | sed "s/ /\n/g" | grep -n "^$name\$" | cut -d: -f1)

if [ "$index" = "" ]; then
    echo "Error: $name isn't a field of $db"
    exit 2
fi

./check.sh "$db.db" f r w
if [ ! $? = 0 ]; then
    exit 1
fi

count=0
tmp=$(mktemp)
while read -r line; do
    if [ ! $(echo "$line" | cut -d" " -f$index) = "$value" ]; then
        echo "$line" >> "$tmp"
    else
        count=$(expr $count + 1)
    fi
done < "$db.db"

cat "$tmp" > "$db.db"
echo "There were $count record(s) deleted from the $db database"
