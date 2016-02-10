#!/bin/bash

# UI for db system
# v1.0
# Tyler Hardin

echo "Options:"
echo -e "\td - create database"
echo -e "\tt - create template"
echo -e "\ts - search for template"
echo "Select an option: "
read opt

case $opt in
    ("d")
        echo -n "Enter the database name: "
        read name
        echo -n "Enter the template name to use: "
        read temp
        ./create_database.sh $temp $name;;
    ("t")
        echo -n "Enter the template name: "
        read name
        echo -n "Enter up to 8 space seperated fields"
        read fields
        ./create_template.sh $name $fields;;
    ("s")
        echo -n "Enter the template definition file name: "
        read f
        echo -n "Enter the template name to search for: "
        read name
        ./template_exists.sh $f $name;;
esac
