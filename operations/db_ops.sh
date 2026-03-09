#!/bin/bash
# shellcheck shell=bash
# ============================================
# File    : operations/database_ops.sh
# Author  : Alaa
# Purpose : Create, List, Connect, Drop Database
# ============================================

create_database() {
    echo -n "Enter Database Name: "
    read -r dbname

    if ! validate_name "$dbname"; then
        return 1
    fi

    if [ -d "$DB_DIR/$dbname" ]; then
        error "Database '$dbname' already exists!"
        return 1
    fi

    mkdir -p "$DB_DIR/$dbname"
    success "Database '$dbname' created successfully."
}

list_databases() {
    if [ -z "$(ls -A "$DB_DIR")" ]; then
        warning "No databases found."
        return
    fi

    info "Available Databases:"
    ls -d "$DB_DIR"/*/  
}

connect_to_database() {
    echo -n "Enter Database Name to connect: "
    read -r dbname

    if ! validate_name "$dbname"; then
        return 1
    fi

    if [ ! -d "$DB_DIR/$dbname" ]; then
        error "Database '$dbname' does not exist!"
        return 1
    fi

    export CURRENT_DB="$dbname"
    export CURRENT_DB_PATH="$DB_DIR/$dbname"
    success "Connected to database: $dbname"
    db_menu
}

drop_database() {
    echo -n "Enter Database Name to drop: "
    read -r dbname

    if ! validate_name "$dbname"; then
        return 1
    fi

    if [ ! -d "$DB_DIR/$dbname" ]; then
        error "Database '$dbname' does not exist!"
        return 1
    fi

    warning "Are you sure you want to drop '$dbname'? (y/n): "
    read -r confirm

    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
       [[ -n "$dbname" ]] && rm -rf "${DB_DIR:?}/$dbname"
        success "Database '$dbname' dropped successfully."
    else
        info "Drop cancelled."
    fi
}