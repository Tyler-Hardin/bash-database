#!/bin/bash
# Sorts and prints a db
# 3/16/2013
# Tyler Hardin
#
# Assumes all state files are correctly formatted
# Assumes databases.txt is db list file

function trim(){
    echo "$1" | sed 's/ *$//g' | sed 's/^ *//g' | cat
}

function fmt_line(){
    in=$(trim "$1")
    almost=$(echo "$in" | sed 's/ /\&/g')
    echo "$almost\\\\"
}

if [ ! "$#" -ge "1" ]; then
    echo "usage: $(basename $0) <db-name> [-n|-r] [field]"
    exit 1
fi

db=$1
name=""
shift
while [ $# -ge 1 ]; do   
    opt=$1
    # Yes, this allows multiple instances of the -n or -r options. You didn't
    # specify otherwise. :) It does require the field name to be last.
    if [ "$opt" = "-n" ]; then
        opts="$opts $opt"
    elif [ "$opt" = "-r" ]; then
        opts="$opts $opt"
    else
        if [ $# = 1 ]; then
            name="$opt"
        else 
            echo "usage: $(basename $0) <db-name> [-n|-r] [field]"
            exit 1
        fi
    fi
    shift
done

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

if [ ! $name = "" ]; then
    index=$(echo "$fields" | sed "s/ /\n/g" | grep -n "^$name\$" | cut -d: -f1)
    if [ "$index" = "" ]; then
        echo "Error: $name isn't a field of $db"
        exit 2
    fi
else
    index=1
fi

./check.sh "$db.db" f r
if [ ! $? = 0 ]; then
    exit 1
fi

tmp_dir=$(mktemp -d)
latex_tmp=$tmp_dir/tbl.tex
echo -n '\documentclass{report}
\begin{document} 
\begin{tabular}{|c' > $latex_tmp
i=1
while [ $i -lt $(echo $fields | wc -w) ]; do
    echo -n " r" >> $latex_tmp
    i=$(expr $i + 1)
done
echo '|}
\hline' >> $latex_tmp

echo $(fmt_line "$fields") >> $latex_tmp
echo '\hline' >> $latex_tmp

sort $opts -k "$index" "$db.db" | while read -r line; do
    echo "$(fmt_line "$line")" >> $latex_tmp
done

echo '\hline
\end{tabular}
\end{document}' >> $latex_tmp

pdf_tmp=$tmp_dir/$(basename $latex_tmp .tex).pdf
pdflatex --output-directory="$tmp_dir" $latex_tmp

okular $pdf_tmp

rm -r $tmp_dir
