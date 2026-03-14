#!/bin/bash

# Menus Shell Script

main_menu() {
    while true; do
        choice=$(zenity --list --title="Bash DBMS - Main Menu" \
            --text="Select an operation:" \
            --column="ID" --column="Action" \
            --hide-column=1 \
            "1" "Create Database" \
            "2" "List Databases" \
            "3" "Connect To Database" \
            "4" "Drop Database" \
            "5" "Exit" \
            --height=350 --width=400)

        # Handle Cancel or Close button
        if [ $? -ne 0 ] || [ -z "$choice" ]; then
            info "Exiting... Goodbye!"
            exit 0
        fi

        case "$choice" in
            1) create_database ;;
            2) list_databases | zenity --text-info --title="Existing Databases" --width=300 --height=400 ;;
            3) connect_to_database ;;
            4) drop_database ;;
            5) info "Exiting... Goodbye!"; exit 0 ;;
            *) error "Unknown option: $choice" ;;
        esac
    done
}

show_db_menu() {
    while true
    do
        choice=$(zenity --list --title="Table Management - $CURRENT_DB" \
            --text="Choose a table operation:" \
            --column="ID" --column="Operation" \
            --hide-column=1 \
            "1" "Create Table" \
            "2" "Insert Into Table" \
            "3" "List Tables" \
            "4" "Select From Table" \
            "5" "Update Table" \
            "6" "Delete From Table" \
            "7" "Drop Table" \
            "8" "Back to Main Menu" \
            --height=450 --width=450)

        # Handle Back or Cancel
        if [ $? -ne 0 ] || [ "$choice" == "8" ] || [ -z "$choice" ]; then
             info "Returning to main menu..."
             break
        fi

        case "$choice" in
            1) create_table ;;
            2) insert_row ;;
            3) list_tables | zenity --text-info --title="Tables in $CURRENT_DB" --width=300 --height=400 ;;
            4) select_rows | zenity --text-info --title="Data Viewer - $CURRENT_DB" --font="Monospace 11" --width=600 --height=400 ;;
            5) update_row ;;
            6) delete_row ;;
            7) drop_table ;;
            *) error "Unknown option: $choice" ;;
        esac
    done
}

