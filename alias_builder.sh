#!/usr/bin/env bash

CONFIG_FILE="$HOME/.zshrc"
[ -f "$HOME/.bashrc" ] && CONFIG_FILE="$HOME/.bashrc"

# Help menu
function alias_help() {
    echo -e "\033[36m=========================\033[0m"
    echo -e "\033[32m       Easy Alias        \033[0m"
    echo -e "\033[36m=========================\033[0m"
    echo -e "\033[33mCommands:\033[0m"
    echo -e "\033[34malias-new\033[0m     - Create a new alias. Prompts for alias name and command."
    echo -e "                Example: \033[32malias-new\033[0m"
    echo -e "\033[34malias-list\033[0m    - List all defined aliases with IDs."
    echo -e "                Example: \033[32malias-list\033[0m"
    echo -e "\033[34malias-delete <ID>\033[0m - Delete an alias by its ID."
    echo -e "                Example: \033[32malias-delete 1\033[0m"
    echo -e "\033[34malias-help\033[0m     - Show this help menu."
    echo -e "                Example: \033[32malias-help\033[0m"
    echo -e "\033[36m=========================\033[0m"
}

# List aliases with IDs
function alias_list() {
    echo -e "\033[32mList of Aliases:\033[0m"
    local i=1
    while IFS= read -r line; do
        local name=$(echo "$line" | sed -E 's/alias ([^=]+)=.*/\1/')
        local cmd=$(echo "$line" | sed -E 's/alias [^=]+="(.+)"/\1/')
        echo -e "[$i] \033[34m$name\033[0m = \033[32m$cmd\033[0m"
        ((i++))
    done < <(grep '^alias ' "$CONFIG_FILE")
}

# Delete an alias by ID
function alias_delete() {
    local id=$1
    if [[ -z "$id" ]]; then
        echo -e "\033[31mError: Please provide an alias ID to delete.\033[0m"
        return 1
    fi

    local aliases=()
    while read -r line; do
        aliases+=("$line")
    done < <(grep '^alias ' "$CONFIG_FILE")

    if [[ $id -le 0 || $id -gt ${#aliases[@]} ]]; then
        echo -e "\033[31mError: Invalid alias ID.\033[0m"
        return 1
    fi

    local alias_to_remove="${aliases[$((id - 1))]}"
    sed -i "/^$alias_to_remove$/d" "$CONFIG_FILE"

    source "$CONFIG_FILE"
    echo -e "\033[32mAlias ID $id successfully deleted.\033[0m"
}

# Alias creation
function alias_new() {
    echo -e "\033[33mEnter alias name:\033[0m"
    read -r alias_name
    echo -e "\033[33mEnter the command for alias '$alias_name':\033[0m"
    read -r alias_command

    if [[ -z "$alias_name" || -z "$alias_command" ]]; then
        echo -e "\033[31mError: Alias name or command cannot be empty.\033[0m"
        return 1
    fi

    echo "alias $alias_name=\"$alias_command\"" >> "$CONFIG_FILE"
    source "$CONFIG_FILE"
    echo -e "\033[32mAlias '$alias_name' added successfully!\033[0m"
}

# Add aliases for the script commands to the shell configuration
if ! grep -q 'alias-new' "$CONFIG_FILE"; then
    echo "alias alias-new='bash $PWD/$(basename "$0")'" >> "$CONFIG_FILE"
fi
if ! grep -q 'alias-list' "$CONFIG_FILE"; then
    echo "alias alias-list='bash $PWD/$(basename "$0") --list'" >> "$CONFIG_FILE"
fi
if ! grep -q 'alias-delete' "$CONFIG_FILE"; then
    echo "alias alias-delete='bash $PWD/$(basename "$0") --delete'" >> "$CONFIG_FILE"
fi
if ! grep -q 'alias-help' "$CONFIG_FILE"; then
    echo "alias alias-help='bash $PWD/$(basename "$0") --help'" >> "$CONFIG_FILE"
fi

# Check for script arguments
case "$1" in
    --list)
        alias_list
        ;;
    --delete)
        alias_delete "$2"
        ;;
    --help)
        alias_help
        ;;
    *)
        alias_new
        ;;
esac
