#!/bin/bash
# shellcheck shell=bash
# ============================================
# File    : operations/validation.sh
# Author  : Alaa
# Purpose : All validation functions
# ============================================
source ./config.sh

# ============================================
# HELPER: Trim leading/trailing spaces
# params: (string)
# returns: trimmed string
# ============================================
trim() {
    local value="$1"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    echo "$value"
}

# ============================================
# Validate DB / Table name
# Rules:
#   - No leading/trailing spaces (auto trim)
#   - Must start with a letter
#   - Only letters, numbers, underscores allowed
#   - No spaces in the middle
#   - Not empty
#   - Max 64 characters (like MySQL)
# params: (name)
# returns: 0=valid, 1=invalid
# ============================================
validate_name() {
    local name
    name=$(trim "$1")

    if [[ -z "$name" ]]; then
        error "Name cannot be empty."
        return 1
    fi

    if [[ "$name" =~ [[:space:]] ]]; then
        error "Name cannot contain spaces. Use underscore '_' instead."
        return 1
    fi

    if [[ ${#name} -gt 64 ]]; then
        error "Name too long. Maximum 64 characters."
        return 1
    fi

    if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        error "Name must start with a letter and contain only letters, numbers, or underscores."
        return 1
    fi

    return 0
}

# ============================================
# Validate data type
# params: (value, type)
# returns: 0=valid, 1=invalid
# ============================================
validate_type() {
    local value="$1"
    local type="$2"

    if [[ -z "$value" ]]; then
        error "Value cannot be empty."
        return 1
    fi

    case "$type" in
        int)
            if [[ "$value" =~ ^-?[0-9]+$ ]]; then
                return 0
            else
                error "Invalid value '$value'. Expected an integer (e.g. 1, 42, -5)."
                return 1
            fi
            ;;
        string)
            if [[ "$value" =~ \| ]]; then
                error "Value cannot contain the '|' character."
                return 1
            fi
            return 0
            ;;
        *)
            error "Unknown datatype '$type'. Supported types: int, string."
            return 1
            ;;
    esac
}

# ============================================
# Check if PK value is unique in table
# params: (table_name, pk_value)
# returns: 0=unique, 1=duplicate
# ============================================
check_pk_unique() {
    local table
    local value
    table=$(trim "$1")
    value=$(trim "$2")

    local meta_file="$CURRENT_DB_PATH/$table$META_EXT"
    local data_file="$CURRENT_DB_PATH/$table$TABLE_EXT"

    if [[ ! -f "$meta_file" ]]; then
        error "Table '$table' does not exist."
        return 1
    fi

    local pk_col_index
    pk_col_index=$(grep -n ":PK" "$meta_file" | cut -d: -f1)

    if [[ -z "$pk_col_index" ]]; then
        error "No primary key defined in table '$table'."
        return 1
    fi

    if [[ ! -f "$data_file" ]]; then
        return 0
    fi

    if cut -d"$DATA_SEP" -f"$pk_col_index" "$data_file" | grep -q "^${value}$"; then
        error "Primary key '$value' already exists. Must be unique."
        return 1
    fi

    return 0
}

# ============================================
# Ensure databases directory exists
# (run once at startup - works on any machine)
# ============================================
ensure_db_dir() {
    if [[ ! -d "$DB_DIR" ]]; then
        mkdir -p "$DB_DIR"
        info "Databases directory created at: $DB_DIR"
    fi
}