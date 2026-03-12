#!/usr/bin/bash

select_rows() {

    read -p "Enter table name: " table_name

    if [[ -z $table_name ]]
    then
        echo "Table name cannot be empty."
        return
    fi

    if ! validate_name "$table_name"
    then
        echo "Invalid table name."
        return
    fi

    meta_file="$CURRENT_DB_PATH/$table_name.meta"
    data_file="$CURRENT_DB_PATH/$table_name.tbl"

    if [[ ! -f $meta_file ]]
    then
        echo "Table does not exist."
        return
    fi

    if [[ ! -s $data_file ]]
    then
        echo "Table is empty."
        return
    fi

    header=""

    while IFS=: read col_name col_type col_key
    do
        if [[ -z $header ]]
        then
            header="$col_name"
        else
            header="$header|$col_name"
        fi
    done < "$meta_file"

    {
        echo "$header"
        cat "$data_file"
    } | column -t -s '|'

}