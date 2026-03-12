#!/usr/bin/bash

select_rows() {

    read -p "Enter table name: " table_name
    table_name=$(trim "$table_name")

    if ! validate_name "$table_name"
    then
        return
    fi

    meta_file="$CURRENT_DB_PATH/$table_name$META_EXT"
    data_file="$CURRENT_DB_PATH/$table_name$TABLE_EXT"

    if [[ ! -f "$meta_file" || ! -f "$data_file" ]]
    then
        error "Table '$table_name' does not exist."
        return
    fi

    if [[ ! -s "$data_file" ]]
    then
        warning "Table '$table_name' is empty."
        return
    fi

    header=""

    while IFS="$META_SEP" read -r col_name rest
    do
        if [[ -z "$header" ]]
        then
            header="$col_name"
        else
            header="$header$DATA_SEP$col_name"
        fi
    done < "$meta_file"

    {
        echo "$header"
        cat "$data_file"
    } | column -t -s "$DATA_SEP"

}