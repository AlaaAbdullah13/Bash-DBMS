#!/bin/bash

# shellcheck source=operations/validations.sh
source ./operations/validations.sh

create_table() {
    read -rp "Enter table name: " table_name
    table_name=$(trim "$table_name")

    if ! validate_name "$table_name"
    then
        return 1
    fi

    meta_file="$CURRENT_DB_PATH/$table_name$META_EXT"
    data_file="$CURRENT_DB_PATH/$table_name$TABLE_EXT"

    if ! validate_connection; then
        return
    fi

    if [[ -f "$meta_file" || -f "$data_file" ]]
    then
        error "Table '$table_name' already exists."
        return 1
    fi

    read -rp "Enter number of columns: " col_count
    if ! [[ "$col_count" =~ ^[0-9]+$ ]] || [ "$col_count" -le 0 ]
    then
        error "Invalid input. Number of columns must be a positive integer."
        return 1
    fi

    col_names=()
    col_types=()

    for (( i=1; i<=col_count; i++ ))
    do
        while true; do
            read -rp "Enter column $i Name: " cname
            cname=$(trim "$cname")
            if validate_name "$cname"; then
                col_names[$i]="$cname"
                break
            fi
        done

        if [[ "${col_names[$i]}" == "id" ]]; then
            col_types[$i]="int"
            info "Column 'id' datatype is fixed as 'int'."
        else
            while true; do
                read -rp "Enter column $i Type (int/string): " ctype
                ctype=$(trim "$ctype" | tr '[:upper:]' '[:lower:]')
                if [[ "$ctype" == "int" || "$ctype" == "string" ]]; then
                    col_types[$i]="$ctype"
                    break
                else
                    error "Invalid type. Use 'int' or 'string'."
                fi
            done
        fi
    done

    # --- Ask for Primary Key ---
    while true; do
        read -rp "Enter the number of the column to be the Primary Key (1-$col_count): " pk_index
        if [[ "$pk_index" =~ ^[0-9]+$ ]] && [ "$pk_index" -ge 1 ] && [ "$pk_index" -le "$col_count" ]; then
            break
        else
            error "Invalid choice. Please enter a number between 1 and $col_count."
        fi
    done

    # Write metadata
    for (( i=1; i<=col_count; i++ ))
    do
        if [[ $i -eq $pk_index ]]; then
            echo "${col_names[$i]}$META_SEP${col_types[$i]}$META_SEP""PK" >> "$meta_file"
        else
            echo "${col_names[$i]}$META_SEP${col_types[$i]}" >> "$meta_file"
        fi
    done

    touch "$data_file"
    success "Table '$table_name' created successfully."
}