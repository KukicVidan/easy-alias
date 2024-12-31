#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Detect shell and config file
if [[ $SHELL == *"zsh"* ]]; then
    CONFIG_FILE="$HOME/.zshrc"
elif [[ $SHELL == *"bash"* ]]; then
    CONFIG_FILE="$HOME/.bashrc"
else
    echo -e "${RED}Unsupported shell. Only Zsh and Bash are supported.${RESET}"
    exit 1
fi

# Backup config file
backup_file="${CONFIG_FILE}.backup"
if [[ ! -f $backup_file ]]; then
    cp "$CONFIG_FILE" "$backup_file"
fi

install_script_aliases() {
    script_path=$(realpath "$0")
    
    # Add alias-new and alias-list
    if ! grep -q "alias alias-new=" "$CONFIG_FILE"; then
        echo "alias alias-new='bash $script_path'" >> "$CONFIG_FILE"
    fi
    if ! grep -q "alias alias-list=" "$CONFIG_FILE"; then
        echo "alias alias-list='bash $script_path --list'" >> "$CONFIG_FILE"
    fi

    # Source config file
    source "$CONFIG_FILE" 2>/dev/null

    echo -e "${GREEN}Script aliases installed successfully!${RESET}"
    echo -e "${CYAN}Use 'alias-new' to create new aliases.${RESET}"
    echo -e "${CYAN}Use 'alias-list' to list all aliases.${RESET}"
}

list_aliases() {
    echo -e "${CYAN}Currently defined aliases:${RESET}"
    grep "^alias " "$CONFIG_FILE" | while read -r line; do
        alias_name=$(echo "$line" | cut -d'=' -f1 | awk '{print $2}')
        alias_command=$(echo "$line" | cut -d'=' -f2- | sed "s/^'//;s/'$//")
        echo -e "${BLUE}${alias_name}${RESET}=${GREEN}${alias_command}${RESET}"
    done
}

create_alias() {
    echo -e "${CYAN}Welcome to the Alias Builder!${RESET}"
    echo -e "This tool helps you create aliases easily.\n"

    # Prompt for alias name
    while true; do
        echo -e "${YELLOW}Enter the alias name:${RESET}"
        read -r alias_name
        if [[ -z "$alias_name" ]]; then
            echo -e "${RED}Alias name cannot be empty. Try again.${RESET}"
            continue
        fi
        # Check if alias already exists
        if grep -q "alias $alias_name=" "$CONFIG_FILE"; then
            echo -e "${RED}Alias '$alias_name' already exists. Choose another name.${RESET}"
            continue
        fi
        break
    done

    # Prompt for alias command
    echo -e "${YELLOW}Enter the command the alias should execute:${RESET}"
    read -r alias_command

    # Append alias to config file
    echo "alias $alias_name='$alias_command'" >> "$CONFIG_FILE"

    # Source the config file
    source "$CONFIG_FILE" 2>/dev/null

    # Success message
    echo -e "${GREEN}Alias '$alias_name' created successfully!${RESET}"
    echo -e "${CYAN}You can now use it in your shell.${RESET}"
}

# Main script logic
if [[ $1 == "--list" ]]; then
    list_aliases
else
    create_alias
    install_script_aliases
fi
