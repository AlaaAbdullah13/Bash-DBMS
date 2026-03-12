#!/bin/bash

source ./validations.sh


create_table() {

    read -p "Enter table name: " table_name

    if ! validate_name "$table_name"; then
        return 1
    fi

    meta_file="$CURRENT_DB_PATH/$table_name$META_EXT"
    data_file="$CURRENT_DB_PATH/$table_name$TABLE_EXT"

    if [[ -f "$meta_file" || -f "$data_file" ]]; then
        error "Table '$table_name' already exists"
        return 1
    fi

    read -p "Enter number of columns: " col_count

    if ! [[ "$col_count" =~ ^[1-9][0-9]*$ ]]; then
        error "Invalid number of columns. Must be a positive integer."
        return 1
    fi

    true > "$meta_file"
    true > "$data_file"

    for (( i=1; i<=col_count; i++ ))
    do
        read -p "Enter column $i name: " col_name

        if ! validate_name "$col_name"; then
            rm -f "$meta_file" "$data_file"
            return 1
        fi

        if [[ "$col_name" == "id" ]]; then
            col_type="int"
            info "Column 'id' datatype is fixed as int"
        else
            read -p "Enter datatype of $col_name (int/string): " col_type

            if [[ "$col_type" != "int" && "$col_type" != "string" ]]; then
                error "Invalid datatype '$col_type'. Supported types: int, string."
                rm -f "$meta_file" "$data_file"
                return 1
            fi
        fi

        if [[ $i -eq 1 ]]; then
            echo "$col_name$META_SEP$col_type$META_SEP""PK" >> "$meta_file"
        else
            echo "$col_name$META_SEP$col_type" >> "$meta_file"
        fi
    done

    success "Table '$table_name' created successfully"
    return 0
}