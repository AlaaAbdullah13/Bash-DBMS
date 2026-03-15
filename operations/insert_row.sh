#!/usr/bin/bash

insert_row() {
    local table_name=$1
    if [[ -z "$table_name" ]]; then
        read -rp "Enter table name: " table_name
    fi
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
    col_index=0

    while IFS="$META_SEP" read -r col_name col_type col_key <&3
    do
        ((col_index++))
        
        while true; do
            read -rp "Enter value for $col_name (type 'q' to cancel): " value
            value=$(trim "$value")

            if [[ "$value" == "q" ]]; then
                info "Returning to menu..."
                return
            fi

            if ! validate_type "$value" "$col_type"; then
                warning "Please try again or enter 'q' to cancel."
                continue
            fi

            if [[ "$col_key" == "PK" ]]; then
                if [[ -z "$value" ]]; then
                    error "Primary Key ($col_name) cannot be empty."
                    continue
                fi
                if ! check_pk_unique "$table_name" "$value"; then
                    continue
                fi
            fi

            break
        done

        if [[ -z "$row" ]]
        then
            row="$value"
        else
            row="$row$DATA_SEP$value"
        fi

    done 3< "$meta_file"

    echo "$row" >> "$data_file"
    success "Row inserted successfully into '$table_name'."
    return 0
}

