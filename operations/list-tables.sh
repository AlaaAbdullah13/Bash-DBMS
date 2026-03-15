#!/usr/bin/bash

list_tables() {

    echo "Available Tables:"

    tables=$(ls "$CURRENT_DB_PATH"/*.meta 2>/dev/null)

    if ! validate_connection; then
        return
    fi

    for table in $tables
    do
        table_name=$(basename "$table" .meta)
        echo "$table_name"
    done

}