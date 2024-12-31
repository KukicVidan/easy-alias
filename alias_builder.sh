#!/usr/bin/env bash

CONFIG_FILE="$HOME/.zshrc" # Change to ~/.bashrc if using bash
[ -f "$HOME/.bashrc" ] && CONFIG_FILE="$HOME/.bashrc"

# List aliases with IDs
function alias_list() {
    echo -e "\033[32mList of Aliases:\033[0m"
    local i=1
    grep '^alias ' "$CONFIG_FILE" | while read -r line; do
        local name=$(echo "$line" | sed -E 's/alias ([^=]+)=.*/\\1/')
        local cmd=$(echo "$line" | sed -E 's/alias [^=]+="(.+)"/\\1/')
        echo -e "[$i] \033[34m$name\033[0m = \033[32m$cmd\033[0m"
        ((i++))
    done
}

# Delete an alias by ID
function alias_delete() {
    local id=$1
    if [[ -z "$id" ]]; then
        echo -e "\033[31mError: Please provide an alias ID to delete.\033[0m"
        return 1
    fi

    # Get all aliases as an array
    local aliases=()
    while read -r line; do
        aliases+=("$line")
    done < <(grep '^alias ' "$CONFIG_FILE")

    if [[ $id -le 0 || $id -gt ${#aliases[@]} ]]; then
        echo -e "\033[31mError: Invalid alias ID.\033[0m"
        return 1
    fi

    # Remove the selected alias
    local alias_to_remove="${aliases[$((id - 1))]}"
    sed -i "/^$alias_to_remove$/d" "$CONFIG_FILE"

    # Reload the configuration
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

    # Append the alias to the configuration file
    echo "alias $alias_name=\"$alias_command\"" >> "$CONFIG_FILE"
    source "$CONFIG_FILE"
    echo -e "\033[32mAlias '$alias_name' added successfully!\033[0m"
}

# Check for script arguments
case "$1" in
    --list)
        alias_list
        ;;
    --delete)
        alias_delete "$2"
        ;;
    *)
        alias_new
        ;;
esac
