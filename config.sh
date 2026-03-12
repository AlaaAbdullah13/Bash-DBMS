#!/bin/bash
#----- Extensions -----
export META_EXT=".meta"
export TABLE_EXT=".tbl"

# ----- Separators -----
export META_SEP=":"
export DATA_SEP="|"

# ----- Paths -----
export DB_DIR="./databases"

# ----- Current Session -----
export CURRENT_DB=""
export CURRENT_DB_PATH=""

# ----- Colors -----
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m'

# ----- Message Format Functions -----
success() { echo -e "${GREEN}[+] $1${NC}"; }
error()   { echo -e "${RED}[-] Error: $1${NC}"; }
warning() { echo -e "${YELLOW}[!] $1${NC}"; }
info()    { echo -e "${BLUE}[*] $1${NC}"; }


# ----- Bootstrap -----
mkdir -p "$DB_DIR"
