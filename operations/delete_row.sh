#!/usr/bin/bash

delete_row() {
    local table_name=$1
    local pk_arg=$2
    
    if [[ -z "$table_name" ]]; then
        read -p "Enter table name: " table_name
    fi
    table_name=$(trim "$table_name")

    # 1. Validate table name format
    if ! validate_name "$table_name"; then
        return
    fi

    # 2. Check if table files exist
    local table_path="$CURRENT_DB_PATH/$table_name$TABLE_EXT"
    if [[ ! -f "$table_path" ]]; then
        error "Table '$table_name' does not exist."
        return
    fi

    # 3. Visual Row Selection
    local pk
    if [[ -n "$pk_arg" ]]; then
        pk="$pk_arg"
    else
        pk=$(get_row_visual_pk "$table_name")
    fi
    
    if [[ $? -ne 0 || -z "$pk" ]]; then
        info "Deletion cancelled."
        return
    fi
    
    # 4. Get PK column index
    local pk_col_index
    pk_col_index=$(grep -n ":PK" "$CURRENT_DB_PATH/$table_name$META_EXT" | cut -d: -f1)

    if [[ -z "$pk_col_index" ]]; then
        error "No Primary Key defined for table '$table_name'."
        return
    fi

    # 5. Confirmation
    # Fetch row data for confirmation message
    local row_data=$(awk -F"$DATA_SEP" -v col="$pk_col_index" -v val="$pk" '$col == val {print $0}' "$table_path")

    if [[ -n "$row_data" ]]; then
        info "Selected row: $row_data"
        read -p "Are you sure you want to delete this row? (y/n): " confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            # Best Practice: Use awk to exclude the row with matching PK
            awk -F"$DATA_SEP" -v col="$pk_col_index" -v val="$pk" '$col != val' "$table_path" > "$table_path.tmp" && mv "$table_path.tmp" "$table_path"
            success "Row with PK '$pk' deleted successfully."
        else
            info "Deletion cancelled."
        fi
    fi
}
