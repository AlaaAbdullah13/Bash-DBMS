#!/usr/bin/bash

drop_table() {

    read -rp "Enter table name to drop: " table_name

    if ! validate_connection; then
        return
    fi

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

    if [[ ! -f $meta_file || ! -f $data_file ]]
    then
        echo "Table does not exist."
        return
    fi

    read -rp "Are you sure you want to delete $table_name ? (y/n): " confirm

    if [[ $confirm == "y" || $confirm == "Y" ]]
    then
        rm "$meta_file"
        rm "$data_file"
        echo "Table dropped successfully."
    else
        echo "Operation cancelled."
    fi

}