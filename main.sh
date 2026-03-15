#!/bin/bash

# Portability: Auto-detect the directory where this script resides 
# and change the working directory to it.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR" || exit 1

# shellcheck source=config.sh
source ./config.sh

# shellcheck source=operations/validations.sh
source ./operations/validations.sh

# shellcheck source=operations/db_ops.sh
source ./operations/db_ops.sh
source ./operations/create-tables.sh
source ./operations/list-tables.sh
source ./operations/drop-tables.sh
source ./operations/insert_row.sh
source ./operations/update_row.sh
source ./operations/delete_row.sh
source ./operations/select_rows.sh
# shellcheck source=menus/menus.sh
source ./menus/menus.sh

clear
echo -e "${BLUE}=============================${NC}"
echo -e "${BLUE}    Bash DBMS - CLI App    ${NC}"
echo -e "${BLUE}=============================${NC}"

ensure_db_dir
main_menu


