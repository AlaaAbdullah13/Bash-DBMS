# Bash Database Management System (DBMS)

A robust, terminal-based Relational Database Management System built entirely in Bash. This project provides a full CRUD interface for managing data on the local filesystem with a professional Graphical User Interface (GUI) powered by Zenity.

## 🚀 Features

### 📂 Database Operations
- **Create/Connect/Drop**: Easily manage multiple siloed databases.
- **Auto-Connect**: Prompt to automatically enter a database immediately after creating it.
- **Safe Deletion**: Confirmation prompts for dropping databases to prevent data loss.

### 📊 Table Operations
- **Full CRUD**: Create Tables, Insert Rows, Select/Read Data, Update Rows, and Delete Rows.
- **Metadata Support**: Each table maintains a `.meta` file defining column names and datatypes (`int`/`string`).
- **Primary Key Enforcement**: Custom validation logic ensures Primary Key uniqueness across table rows.
- **Flexible PK Selection**: Choose any column as your Primary Key during table creation.
- **ID Auto-increment**: Special `id` column support that automatically generates the next sequential ID.

### 🎨 User Interface
- **Modern GUI**: Powered by **Zenity**, utilizing desktop pop-up windows for menus and data display.
- **Formatted Output**: Tabular data display using the `column` utility for high readability.
- **Error Handling**: Beautifully colored messages and descriptive error dialogs.

## 🛠️ Requirements
- **OS**: Linux (tested on ThinkPad X1 Carbon)
- **Dependencies**: 
  - `bash` (v4+)
  - `zenity` (for the GUI)
  - `util-linux` (for the `column` command)

## 📥 Installation & Usage

1. **Clone the project**
   ```bash
   git clone [repository-url]
   cd BashProject
   ```

2. **Grant execution permissions**
   ```bash
   chmod +x main.sh config.sh operations/*.sh menus/*.sh
   ```

3. **Run the application**
   ```bash
   ./main.sh
   ```

## 🌍 Global Accessibility

To run the DBMS from anywhere without typing the full path:

1. **Add to PATH (for the current session)**:
   ```bash
   export PATH="$PATH:$(pwd)"
   ```

2. **Create a permanent shortcut (Symlink)**:
   ```bash
   sudo ln -s "$(pwd)/main.sh" /usr/local/bin/bashdbms
   ```
   *Now you can just type `bashdbms` from any folder!*

## 📂 Project Structure
- `main.sh`: Entry point of the application.
- `config.sh`: Global configuration and color definitions.
- `menus/`: Contains UI logic (Zenity menus).
- `operations/`: Core logic for DB and Table manipulation.
- `databases/`: Default directory where data is stored.

## 👥 Contributors
- **Alaa Salem**
- **Haneen Elasawy**

---
*Created as part of the Bash DBMS course project.*
