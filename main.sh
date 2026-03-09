#!/bin/bash
# Main Entry Point

# shellcheck source=./config.sh
source ./config.sh
# shellcheck source=./operations/db_ops.sh
source ./operations/db_ops.sh
# shellcheck source=./menus/menus.sh
source ./menus/menus.sh

clear
echo -e "${BLUE}=============================${NC}"
echo -e "${BLUE}    Bash DBMS - CLI App    ${NC}"
echo -e "${BLUE}=============================${NC}"

main_menu