#!/bin/bash

create_table() {

    read -p "Enter table name: " table_name

    if [[ -z "$table_name" ]]; then
        echo "Table name cannot be empty"
        return
    fi

    if ! validate_name "$table_name"; then
        echo "Invalid table name"
        return
    fi

    meta_file="$CURRENT_DB_PATH/$table_name$META_EXT"
    data_file="$CURRENT_DB_PATH/$table_name$TABLE_EXT"

    if [[ -f "$meta_file" || -f "$data_file" ]]; then
        echo "Table already exists"
        return
    fi

    read -p "Enter number of columns: " col_count

    if ! [[ "$col_count" =~ ^[1-9][0-9]*$ ]]; then
        echo "Invalid number of columns"
        return
    fi

    > "$meta_file"
    > "$data_file"

    for (( i=1; i<=col_count; i++ ))
    do
        read -p "Enter column $i name: " col_name

        if [[ -z "$col_name" ]]; then
            echo "Column name cannot be empty"
            rm -f "$meta_file" "$data_file"
            return
        fi

        if ! validate_name "$col_name"; then
            echo "Invalid column name"
            rm -f "$meta_file" "$data_file"
            return
        fi

        if [[ "$col_name" == "id" ]]; then
            col_type="int"
            echo "id datatype is fixed as int"
        else
            read -p "Enter datatype of $col_name (int/string): " col_type

            if [[ "$col_type" != "int" && "$col_type" != "string" ]]; then
                echo "Invalid datatype"
                rm -f "$meta_file" "$data_file"
                return
            fi
        fi

        if [[ $i -eq 1 ]]; then
            echo "$col_name$META_SEP$col_type$META_SEP""PK" >> "$meta_file"
        else
            echo "$col_name$META_SEP$col_type" >> "$meta_file"
        fi
    done

    echo "Table created successfully"
}