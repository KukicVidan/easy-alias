#!/bin/bash

# Determine the shell config file based on the active shell (Bash or Zsh)
SHELL_CONFIG_FILE="$HOME/.zshrc"   # Default to Zsh
if [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG_FILE="$HOME/.bashrc"  # Use .bashrc for Bash
fi

# Backup the shell config file before modifying
BACKUP_FILE="$SHELL_CONFIG_FILE.backup"
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$SHELL_CONFIG_FILE" "$BACKUP_FILE"
    echo "Backup of your shell configuration file created at $BACKUP_FILE"
fi

# Function to check if the aliases are already set up in the shell config file
setup_aliases() {
    # Check if aliases are already set in the config file
    if ! grep -q "alias alias-new=" "$SHELL_CONFIG_FILE"; then
        echo "Setting up aliases in your shell config file..."
        
        # Add the aliases to the shell config file
        echo "alias alias-new='bash $0 alias-new'" >> "$SHELL_CONFIG_FILE"
        echo "alias alias-list='bash $0 alias-list'" >> "$SHELL_CONFIG_FILE"
        
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

# Function to list all aliases with color coding
alias_list() {
    echo -e "\nList of Aliases:"
    alias | while read -r line; do
        # Extract alias name and command
        alias_name=$(echo "$line" | awk '{print $2}' | sed "s/alias \(.*\)=.*/\1/")
        alias_command=$(echo "$line" | sed "s/alias .*=//")

        # Color-coded output
        echo -e "\033[34m$alias_name\033[0m = \033[32m$alias_command\033[0m"
    done
}

# Main script logic based on passed argument
if [ -z "$1" ]; then
    # Setup aliases if not already set up
    setup_aliases
    echo "Please use the following commands to manage aliases:"
    echo "  alias-new        : Add a new alias"
    echo "  alias-list       : List all aliases"
else
    case "$1" in
        alias-new)
            alias_new
            ;;
        alias-list)
            alias_list
            ;;
        *)
            echo "Usage: $0 [alias-new|alias-list]"
            ;;
    esac
fi
