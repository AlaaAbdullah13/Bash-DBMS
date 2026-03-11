#!/bin/bash

show_db_menu() {
    while true
    do
        echo
        info "Current Database: $CURRENT_DB"
        echo "1) Create Table"
        echo "2) Insert Into Table"
        echo "3) List Tables"
        echo "4) Select From Table"
        echo "5) Drop Table"
        echo "6) Exit to Main Menu"
        echo

        read -r -p "Choose option: " choice
        normalized_choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

        case "$normalized_choice" in
            1 | "create table")
                create_table
                ;;
            2 | "insert into table")
                insert_row
                ;;
            3 | "list tables")
                list_tables
                ;;
            4 | "select from table")
                select_rows
                ;;
            5 | "drop table")
                drop_table
                ;;
            6 | "exit" | "exit to main menu")
                info "Returning to main menu..."
                break
                ;;
            *)
                error "Invalid option. Please choose a valid number or operation name."
                ;;
        esac
    done
}