#!/bin/bash

# Database Operations Shell Script

create_database() {
    echo -n "Enter Database Name: "
    read dbname
    if validate_name "$dbname"; then
        if [ -d "$DB_DIR/$dbname" ]; then
            error "Database '$dbname' already exists!"
        else
            mkdir -p "$DB_DIR/$dbname"
            success "Database '$dbname' created successfully."
        fi
    else
        error "Invalid Name! Use only alphanumeric characters and underscores."
    fi
}

list_databases() {
    info "Available Databases:"
    ls -F "$DB_DIR" | grep / | tr / " "
}

connect_to_database() {
    echo -n "Enter Database Name to connect: "
    read dbname
    if [ -d "$DB_DIR/$dbname" ] && [ -n "$dbname" ]; then
        export CURRENT_DB="$dbname"
        export CURRENT_DB_PATH="$DB_DIR/$dbname"
        success "Connected to database: $dbname"
        # Call Database Menu here (to be implemented)
        db_menu
    else
        error "Database '$dbname' does not exist!"
    fi
}

drop_database() {
    echo -n "Enter Database Name to drop: "
    read dbname
    if [ -d "$DB_DIR/$dbname" ] && [ -n "$dbname" ]; then
        rm -rf "$DB_DIR/$dbname"
        success "Database '$dbname' dropped successfully."
    else
        error "Database '$dbname' does not exist!"
    fi
}
