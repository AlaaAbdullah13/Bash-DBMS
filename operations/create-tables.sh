#!/bin/bash

create_table() {

    read -r -p "Enter table name: " table_name

    if [[ -z "$table_name" ]]; then
        error "Table name cannot be empty."
        return 1
    fi

    if ! validate_name "$table_name"; then
        error "Invalid table name."
        return 1
    fi

    meta_file="$CURRENT_DB_PATH/${table_name}${META_EXT}"
    data_file="$CURRENT_DB_PATH/${table_name}${TABLE_EXT}"

    if [[ -f "$meta_file" ]]; then
        error "Table already exists."
        return 1
    fi

    read -r -p "Enter number of columns: " col_count

    if ! [[ "$col_count" =~ ^[1-9][0-9]*$ ]]; then
        error "Invalid column number."
        return 1
    fi

    declare -a columns
    declare -a types

    for (( i=1; i<=col_count; i++ ))
    do
        read -r -p "Enter column $i name: " col_name

        if ! validate_name "$col_name"; then
            error "Invalid column name."
            return 1
        fi

        read -r -p "Enter datatype for $col_name (int/string): " col_type

        if [[ "$col_type" != "int" && "$col_type" != "string" ]]; then
            error "Datatype must be int or string."
            return 1
        fi

        columns[$i]="$col_name"
        types[$i]="$col_type"
    done

    read -r -p "Enter primary key column number: " pk_index

    if ! [[ "$pk_index" =~ ^[1-9][0-9]*$ ]] || (( pk_index < 1 || pk_index > col_count )); then
        error "Invalid primary key column number."
        return 1
    fi

    > "$meta_file"
    > "$data_file"

    for (( i=1; i<=col_count; i++ ))
    do
        if (( i == pk_index )); then
            echo "${columns[$i]}${META_SEP}${types[$i]}${META_SEP}PK" >> "$meta_file"
        else
            echo "${columns[$i]}${META_SEP}${types[$i]}" >> "$meta_file"
        fi
    done

    success "Table '$table_name' created successfully."

}