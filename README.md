# Bash DBMS

A simple Database Management System (DBMS) built with Bash Shell Scripts. This project enables users to store and retrieve data from the hard disk through a CLI interface.

## Features
- **Main Menu**: Create, List, Connect to, and Drop Databases.
- **Database Menu**: Create Table, List Tables, Drop Table, Insert, Select, Delete, and Update.
- **Data Validation**: Checks for data types and Primary Key uniqueness.
- **Storage**: Databases are stored as directories; tables use structured text files.

## Getting Started
1. Clone the repository: `git clone <repo-url>`
2. Give execution permissions: `chmod +x main.sh`
3. Run the application: `./main.sh`

## Project Structure
- `main.sh`: Entry point.
- `config.sh`: Global configurations and utilities.
- `menus/`: Shell scripts for UI menus.
- `operations/`: Logic for database and table operations.
- `databases/`: Default directory for storing data.
