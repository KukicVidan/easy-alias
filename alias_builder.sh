#!/bin/bash

# Determine the shell config file based on the active shell (Bash or Zsh)
SHELL_CONFIG_FILE="$HOME/.zshrc"   # Default to Zsh
if [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG_FILE="$HOME/.bashrc"  # Use .bashrc for Bash
fi

# Function to check if the aliases are already set up in the shell config file
setup_aliases() {
    # Check if aliases are already set in the config file
    if ! grep -q "alias alias-new=" "$SHELL_CONFIG_FILE"; then
        echo "Setting up aliases in your shell config file..."
        
        # Add the aliases to the shell config file
        echo "alias alias-new='bash $0 alias-new'" >> "$SHELL_CONFIG_FILE"
        echo "alias alias-list='bash $0 alias-list'" >> "$SHELL_CONFIG_FILE"
        echo "alias alias-delete='bash $0 alias-delete'" >> "$SHELL_CONFIG_FILE"
        echo "alias alias-help='bash $0 alias-help'" >> "$SHELL_CONFIG_FILE"
        
        # Reload shell config file to apply aliases immediately
        echo "Aliases set up successfully!"
        echo "Reloading your shell configuration..."

        source "$SHELL_CONFIG_FILE"  # Reload to apply the new aliases
    fi
}

# Function to add a new alias
alias_new() {
    read -p "Enter alias name: " alias_name
    read -p "Enter the command for alias '$alias_name': " alias_command

    # Append the new alias to the shell config file
    echo "alias $alias_name='$alias_command'" >> "$SHELL_CONFIG_FILE"
    echo "Alias '$alias_name' added successfully!"
    
    # Reload config file
    source "$SHELL_CONFIG_FILE"
}

# Function to list all aliases
alias_list() {
    echo "List of Aliases:"
    alias | nl -w 2 -s '. '  # List aliases with line numbers
}

# Function to delete an alias by ID
alias_delete() {
    read -p "Enter alias ID to delete: " alias_id

    # List all aliases and select the one to delete
    alias | nl -w 2 -s '. ' | sed -n "${alias_id}p" | while read -r line; do
        alias_name=$(echo "$line" | awk '{print $2}' | sed "s/alias \(.*\)=.*/\1/")
        # Remove alias from the config file
        if grep -q "alias $alias_name=" "$SHELL_CONFIG_FILE"; then
            sed -i "/alias $alias_name=/d" "$SHELL_CONFIG_FILE"
            echo "Alias '$alias_name' deleted successfully!"
        else
            echo "Alias '$alias_name' not found in $SHELL_CONFIG_FILE."
        fi
    done
    
    # Reload config file
    source "$SHELL_CONFIG_FILE"
}

# Function to display help
alias_help() {
    echo "Alias Manager Help:"
    echo "  alias-new        : Add a new alias"
    echo "  alias-list       : List all aliases"
    echo "  alias-delete <ID>: Delete an alias by its ID"
    echo "  alias-help       : Show this help message"
}

# Main script logic based on passed argument
if [ -z "$1" ]; then
    # Setup aliases if not already set up
    setup_aliases
    echo "Please use the following commands to manage aliases:"
    echo "  alias-new        : Add a new alias"
    echo "  alias-list       : List all aliases"
    echo "  alias-delete     : Delete an alias by its ID"
    echo "  alias-help       : Show this help message"
else
    case "$1" in
        alias-new)
            alias_new
            ;;
        alias-list)
            alias_list
            ;;
        alias-delete)
            alias_delete
            ;;
        alias-help)
            alias_help
            ;;
        *)
            echo "Usage: $0 [alias-new|alias-list|alias-delete <ID>|alias-help]"
            ;;
    esac
fi
