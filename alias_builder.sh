#!/bin/bash

CONFIG_FILE="$HOME/.zshrc"  # Zsh configuration file
SCRIPT_NAME=$(basename "$0")

# Add a new alias
alias_new() {
    read -p "Enter alias name: " alias_name
    read -p "Enter the command for alias '$alias_name': " alias_command

    # Append alias to config file
    echo "alias $alias_name='$alias_command'" >> "$CONFIG_FILE"
    echo "Alias '$alias_name' added successfully!"
    
    # Reload config file
    source "$CONFIG_FILE"
}

# List all aliases
alias_list() {
    echo "List of Aliases:"
    alias | nl -w 2 -s '. '  # List aliases with line numbers
}

# Delete an alias
alias_delete() {
    read -p "Enter alias name to delete: " alias_name

    # Remove alias from the config file
    if grep -q "alias $alias_name=" "$CONFIG_FILE"; then
        sed -i "/alias $alias_name=/d" "$CONFIG_FILE"
        echo "Alias '$alias_name' deleted successfully!"
        
        # Reload config file
        source "$CONFIG_FILE"
    else
        echo "Alias '$alias_name' not found."
    fi
}

# Display help message
alias_help() {
    echo "Alias Manager Help:"
    echo "  alias-new        : Add a new alias"
    echo "  alias-list       : List all aliases"
    echo "  alias-delete     : Delete an alias"
    echo "  alias-help       : Show this help message"
}

# Main script logic
case "$1" in
    --new)
        alias_new
        ;;
    --list)
        alias_list
        ;;
    --delete)
        alias_delete
        ;;
    --help)
        alias_help
        ;;
    *)
        echo "Usage: $SCRIPT_NAME [--new|--list|--delete|--help]"
        ;;
esac
