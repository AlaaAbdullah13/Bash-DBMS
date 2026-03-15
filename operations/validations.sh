#!/bin/bash
# shellcheck shell=bash
# ============================================
source ./config.sh

trim() {
    local value="$1"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    echo "$value"
}

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

    if [[ "$name" =~ \\ ]]; then
        error "Name cannot contain backslashes '\'."
        return 1
    fi

    if [[ ! "$name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        error "Name must start with a letter and contain only letters, numbers, or underscores."
        return 1
    fi

    return 0
}

validate_type() {
    local value="$1"
    local type="$2"

    if [[ -z "$value" ]]; then
        return 0
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
            if [[ "$value" =~ \\ ]]; then
                error "Value cannot contain backslashes '\'."
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
# HELPER: Get PK column index for a table
# params: (table_name)
# returns: index (printed), 1 on error
# ============================================
get_pk_index() {
    local table=$1
    local meta_file="$CURRENT_DB_PATH/$table$META_EXT"
    
    if [[ ! -f "$meta_file" ]]; then
        return 1
    fi

    local pk_col_index
    pk_col_index=$(grep -n ":PK" "$meta_file" | cut -d: -f1)
    
    if [[ -n "$pk_col_index" ]]; then
        echo "$pk_col_index"
        return 0
    else
        return 1
    fi
}

# ============================================
# Check if PK value is unique in table
# params: (table_name, pk_value)
# returns: 0=unique, 1=duplicate
# ============================================
check_pk_unique() {
    local table="$1"
    local value="$2"
    local data_file="$CURRENT_DB_PATH/$table$TABLE_EXT"

    local pk_col_index
    pk_col_index=$(get_pk_index "$table")

    if [[ $? -ne 0 ]]; then
        error "No primary key defined in table '$table'."
        return 1
    fi

    # If data file is empty/missing, it's unique by definition
    if [[ ! -s "$data_file" ]]; then
        return 0
    fi

    if cut -d"$DATA_SEP" -f"$pk_col_index" "$data_file" | grep -q "^${value}$"; then
        error "Primary key '$value' already exists. Must be unique."
        return 1
    fi

    return 0
}


get_row_visual_pk() {
    local table=$1
    local provided_pk=$2 
    
    if [[ -n "$provided_pk" ]]; then
        echo "$provided_pk"
        return 0
    fi

    local meta_file="$CURRENT_DB_PATH/$table$META_EXT"
    local data_file="$CURRENT_DB_PATH/$table$TABLE_EXT"

    if [[ ! -f "$meta_file" || ! -f "$data_file" ]]; then
        return 1
    fi

    if [[ ! -s "$data_file" ]]; then
        return 1
    fi

    local args=("--list" "--title=Select Row" "--text=Choose a record from '$table':" "--height=400" "--width=600")
    local col_index=0
    local pk_idx=1
    while IFS="$META_SEP" read -r col_name col_type col_key; do
        ((col_index++))
        args+=("--column=$col_name")
        if [[ "$col_key" == "PK" ]]; then
            pk_idx=$col_index
        fi
    done < "$meta_file"

    local selected_pk
    selected_pk=$(cat "$data_file" | sed "s/$DATA_SEP/\n/g" | zenity "${args[@]}" --print-column="$pk_idx" 2>/dev/null)
    
    if [[ $? -eq 0 && -n "$selected_pk" ]]; then
        echo "$selected_pk"
        return 0
    else
        return 1
    fi
}


ensure_db_dir() {
    if [[ ! -d "$DB_DIR" ]]; then
        mkdir -p "$DB_DIR"
        info "Databases directory created at: $DB_DIR"
    fi
}