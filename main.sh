#!/bin/bash

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
source ./operations/select_rows.sh
# shellcheck source=menus/menus.sh
source ./menus/menus.sh
source ./menus/db_menu.sh

clear
echo -e "${BLUE}=============================${NC}"
echo -e "${BLUE}    Bash DBMS - CLI App    ${NC}"
echo -e "${BLUE}=============================${NC}"

ensure_db_dir
main_menu

CURRENT_DB="testdb"
CURRENT_DB_PATH="$DB_DIR/$CURRENT_DB"

mkdir -p "$CURRENT_DB_PATH"

echo "Welcome to Bash DBMS" 

show_db_menu


