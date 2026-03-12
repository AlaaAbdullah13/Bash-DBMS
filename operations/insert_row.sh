#!/usr/bin/bash

insert_row() {

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

    row=""

    while IFS="$META_SEP" read -r col_name col_type col_key
    do
        read -p "Enter value for $col_name: " value
        value=$(trim "$value")

        if ! validate_type "$value" "$col_type"
        then
            return
        fi

        if [[ "$col_key" == "PK" ]]
        then
            if ! check_pk_unique "$table_name" "$value"
            then
                return
            fi
        fi

        if [[ -z "$row" ]]
        then
            row="$value"
        else
            row="$row$DATA_SEP$value"
        fi

    done < "$meta_file"

    echo "$row" >> "$data_file"
    success "Row inserted successfully into '$table_name'."

}