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
        read choice

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
    while true; do
        echo -e "\n${YELLOW}--- Database: $CURRENT_DB ---${NC}"
        echo "1. Create Table"
        echo "2. List Tables"
        echo "3. Drop Table"
        echo "4. Insert into Table"
        echo "5. Select From Table"
        echo "6. Delete From Table"
        echo "7. Update Table"
        echo "8. Back to Main Menu"
        echo -n "Select an option: "
        read choice

        case $choice in
            1) echo "Create table placeholder" ;; # To be implemented
            2) echo "List tables placeholder" ;; # To be implemented
            3) echo "Drop table placeholder" ;; # To be implemented
            4) echo "Insert placeholder" ;; # To be implemented
            5) echo "Select placeholder" ;; # To be implemented
            6) echo "Delete placeholder" ;; # To be implemented
            7) echo "Update placeholder" ;; # To be implemented
            8) return ;;
            *) error "Invalid choice. Please try again." ;;
        esac
    done
}
