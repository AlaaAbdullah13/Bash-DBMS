#!/usr/bin/bash

update_row() {
    local table_name=$1
    local pk_arg=$2
    
    if [[ -z "$table_name" ]]; then
        read -rp "Enter table name: " table_name
    fi
    table_name=$(trim "$table_name")

    if ! validate_name "$table_name"; then
        return
    fi

    if ! validate_connection; then
        return
    fi
    local table_path="$CURRENT_DB_PATH/$table_name$TABLE_EXT"
    if ! validate_table_exists "$table_name"; then
        return
    fi

    local pk
    if [[ -n "$pk_arg" ]]; then
        pk="$pk_arg"
    else
        pk=$(get_row_visual_pk "$table_name")
    fi
    
    if [[ $? -ne 0 || -z "$pk" ]]; then
        info "Update cancelled."
        return
    fi

      # 4. Get table information
    local meta_file="$CURRENT_DB_PATH/$table_name$META_EXT"
    local pk_col_index
    pk_col_index=$(get_pk_index "$table_name")

    if [[ $? -ne 0 ]]; then
        error "No Primary Key defined for table '$table_name'."
        return
    fi

    local line_info
    line_info=$(awk -F"[$DATA_SEP]" -v col="$pk_col_index" -v val="$pk" '$col == val {print NR "|" $0}' "$table_path")
    
    if [[ -z "$line_info" ]]; then
        error "Could not locate row with PK '$pk'."
        return
    fi

    local line_num=$(echo "$line_info" | cut -d'|' -f1)
    local old_row_data=$(echo "$line_info" | cut -d'|' -f2-)
    
    info "Updating record: $old_row_data"
    info "Note: The Primary Key cannot be changed (Best Practice)."

    local new_row=""
    local col_index=0
    
    while IFS="$META_SEP" read -r col_name col_type col_key <&3
    do
        ((col_index++))
        local current_val=$(echo "$old_row_data" | cut -d"$DATA_SEP" -f"$col_index")
        local new_val=""

        if [[ "$col_key" == "PK" ]]; then
            new_val="$current_val"
        else
            read -rp "Enter new value for $col_name (Leave empty to keep '$current_val', 'q' to cancel): " input
            input=$(trim "$input")
            
            if [[ "$input" == "q" ]]; then
                warning "Update cancelled."
                return
            fi
            
            if [[ -z "$input" ]]; then
                new_val="$current_val"
            else
                if ! validate_type "$input" "$col_type"; then
                    warning "Invalid type. Keeping original value '$current_val'."
                    new_val="$current_val"
                else
                    new_val="$input"
                fi
            fi
        fi

        if [[ -z "$new_row" ]]; then
            new_row="$new_val"
        else
            new_row="$new_row$DATA_SEP$new_val"
        fi
    done 3< "$meta_file"

    awk -v target="$line_num" -v replacement="$new_row" 'NR == target {print replacement; next} {print}' "$table_path" > "$table_path.tmp" && mv "$table_path.tmp" "$table_path"

    success "Row updated successfully in-place."
}
