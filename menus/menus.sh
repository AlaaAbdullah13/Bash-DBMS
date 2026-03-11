#!/bin/bash

# Menus Shell Script

main_menu() {
    while true; do
        echo -e "\n${BLUE}--- Main Menu ---${NC}"
        echo "1. Create Database"
        echo "2. List Databases"
        echo "3. Connect To Database"
        echo "4. Drop Database"
        echo "5. Exit"
        echo -n "Select an option: "
        read -r choice

        case $choice in
            1) create_database ;;
            2) list_databases ;;
            3) connect_to_database ;;
            4) drop_database ;;
            5) info "Exiting... Goodbye!"; exit 0 ;;
            *) error "Invalid choice. Please try again." ;;
        esac
    done
}

db_menu() {
    # Placeholder for collaborator's table management menu
    echo -e "${YELLOW}Entering Database Menu ${NC}"
}

