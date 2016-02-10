#!/bin/bash

# Tyler Hardin
# Tests stuff

echo -n "" >| math_dep.db
echo First1 Last1 1 | ./insert_record.sh math_dep
echo First2 Last2 0 | ./insert_record.sh math_dep
echo First3 Last3 1 | ./insert_record.sh math_dep
echo a d f | ./insert_record.sh math_dep
echo w t y | ./insert_record.sh math_dep
#echo "NotEnoughFields" | ./insert_record.sh math_dep
#echo Too Many Fields s | ./insert_record.sh
cat math_dep.db
echo blah foo | ./insert_record.sh non_existant_db

./delete_record.sh math_dep ten 0
cat math_dep.db
./delete_record.sh math_dep tenure 0
cat math_dep.db

./print_db.sh math_dep -r last
