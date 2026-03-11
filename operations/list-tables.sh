#!/bin/bash

list_tables() {
    if [[ -z "$CURRENT_DB_PATH" || ! -d "$CURRENT_DB_PATH" ]]; then
        error "No database selected or database path is invalid."
        return 1
    fi

    local found=0

    for file in "$CURRENT_DB_PATH"/*"$META_EXT"
    do
        if [[ -f "$file" ]]; then
            basename "$file" "$META_EXT"
            found=1
        fi
    done

    if [[ $found -eq 0 ]]; then
        warning "No tables found in database '$CURRENT_DB'."
    fi
}