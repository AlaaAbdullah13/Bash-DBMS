#!/bin/bash

source ./config.sh

source ./menus/db_menu.sh

source ./operations/create-tables.sh
source ./operations/list-tables.sh
#source ./operations/drop-tables.sh
#source ./operations/insert_row.sh
#source ./operations/select_rows.sh

CURRENT_DB="testdb"
CURRENT_DB_PATH="$DB_DIR/$CURRENT_DB"

mkdir -p "$CURRENT_DB_PATH"

echo "Welcome to Bash DBMS" 

show_db_menu

# Here you will call the main menu function later