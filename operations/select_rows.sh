#!/usr/bin/bash

select_rows() {

    read -rp "Enter table name: " table_name
    table_name=$(trim "$table_name")

    if ! validate_connection; then
        return
    fi
    if ! validate_table_exists "$table_name"; then
        return
    fi

    if ! validate_table_exists "$table_name"; then
        return
    fi

    meta_file="$CURRENT_DB_PATH/$table_name$META_EXT"
    data_file="$CURRENT_DB_PATH/$table_name$TABLE_EXT"

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
        sort -t"$DATA_SEP" -k1,1n "$data_file"
    } | column -t -s "$DATA_SEP"

}