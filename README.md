# Easy Alias 
#fixing app at the moment. not usable.

Easy Alias is a lightweight and user-friendly command-line tool designed to simplify the creation and management of shell aliases. This script allows users to quickly define new aliases, view existing ones, and immediately use them in their shell environment.

## Features

- **Create New Aliases**: Prompt-based alias creation with real-time feedback.
- **List Existing Aliases**: Display all defined aliases in a color-coded format for easy reading.
  - Alias names are displayed in **blue**.
  - Alias commands are displayed in **green**.
- **Auto-Installation**: The script automatically adds itself as:
  - `alias-new`: For creating new aliases.
  - `alias-list`: For listing all existing aliases.
- **Backup Configuration**: Creates a backup of the shell configuration file (`~/.zshrc` or `~/.bashrc`) before making changes.
- **Shell Compatibility**: Supports Zsh and Bash shells.
- **Immediate Usage**: Sources the shell configuration file so aliases are available immediately.

## Installation

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/KukicVidan/easy-alias.git
   ```

2. **Navigate to the Directory**:

   ```bash
   cd easy-alias
   ```

3. **Make the Script Executable**:

   ```bash
   chmod +x alias_builder.sh
   ```

## Usage

### Run the Script

To start the alias builder, simply execute the script:

```bash
./alias_builder.sh
```

### Create a New Alias

1. The script will prompt you to enter the alias name.
2. Then, you’ll be prompted to enter the command the alias should execute.
3. The alias will be saved and made immediately available in your shell.

Alternatively, once the script is run for the first time, you can use:

```bash
alias-new
```

This command performs the same functionality as running the script.

### List Existing Aliases

To list all currently defined aliases, use the command:

```bash
alias-list
```

This will display a color-coded list of aliases, where:

- **Alias names** are in blue.
- **Alias commands** are in green.

### Backup Configuration

A backup of your shell configuration file is created at `~/.zshrc.backup` or `~/.bashrc.backup` during the first run.

### Uninstallation

To remove Easy Alias and its associated functionality:

1. Open your shell configuration file (`~/.zshrc` or `~/.bashrc`) in a text editor:
   ```bash
   nano ~/.zshrc
   # or
   nano ~/.bashrc
   ```
2. Delete the following lines:
   ```bash
   alias alias-new='bash /path/to/alias_builder.sh'
   alias alias-list='bash /path/to/alias_builder.sh --list'
   ```
3. Save the file and exit the editor.
4. Source the shell configuration file to apply changes:
   ```bash
   source ~/.zshrc
   # or
   source ~/.bashrc
   ```
5. Optionally, delete the script and repository folder:
   ```bash
   rm -rf /path/to/easy-alias
   ```

## Example Workflow

1. Run the script to initialize it:
   ```bash
   ./alias_builder.sh
   ```
2. Create an alias for listing files:
   - Enter alias name: `lsf`
   - Enter command: `ls -lh`
3. Use the alias immediately:
   ```bash
   lsf
   ```
4. List all aliases:
   ```bash
   alias-list
   ```
   Output:
   ```bash
   lsf=ls -lh
   ```

## Notes

- The script modifies your shell configuration file (`~/.zshrc` or `~/.bashrc`) to store aliases and add the `alias-new` and `alias-list` commands.
- If you switch shells, rerun the script to configure the aliases for the new shell.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your improvements.

## License

This project is licensed under the MIT License. You are free to use, modify, and distribute this software.

