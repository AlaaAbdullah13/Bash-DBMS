#!/usr/bin/bash

insert_row() {

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

    row=""

    while IFS=: read col_name col_type col_key
    do
        read -p "Enter value for $col_name: " value

        if [[ -z $value ]]
        then
            echo "Value cannot be empty."
            return
        fi

        if [[ $col_type == "int" ]]
        then
            if ! validate_number "$value"
            then
                echo "$col_name must be integer."
                return
            fi
        fi

        if [[ $col_key == "PK" ]]
        then
            pk_exists=$(cut -d'|' -f1 "$data_file" 2>/dev/null | grep -w "$value")

            if [[ ! -z $pk_exists ]]
            then
                echo "Primary key already exists."
                return
            fi
        fi

        if [[ -z $row ]]
        then
            row="$value"
        else
            row="$row|$value"
        fi

    done < "$meta_file"

    echo "$row" >> "$data_file"

    echo "Row inserted successfully."

}