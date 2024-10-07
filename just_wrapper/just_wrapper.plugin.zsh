JW_COMMANDS_DIR="$ZSH_CUSTOM/plugins/just_wrapper/commands/"
JW_COMMANDS_FILE="$JW_COMMANDS_DIR/.commands"
chmod +x "$JW_COMMANDS_FILE"

# Get all the functions in the commands file
JW_COMMANDS=$(awk '/^function/ {print $2}' "$JW_COMMANDS_FILE" | sed 's/()//')

# Add any script in the commands directory (excluding .commands)
JW_SCRIPTS=$(ls "$JW_COMMANDS_DIR" | grep -v '.commands' | sed 's/\.sh//')


autoload -Uz just_wrapper