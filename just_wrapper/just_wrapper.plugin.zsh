JW_COMMANDS_DIR="$ZSH_CUSTOM/plugins/just_wrapper/commands/"
JW_COMMANDS_FILE="$JW_COMMANDS_DIR/.commands"
chmod +x "$JW_COMMANDS_FILE"

# Get all the functions in the commands file
JW_COMMANDS=$(awk '/^function/ {print $2}' "$JW_COMMANDS_FILE" | sed 's/()//')

# Add any script in the commands directory (excluding .commands)
JW_SCRIPTS=$(ls "$JW_COMMANDS_DIR" | grep -v '.commands' | sed 's/\.sh//')

# Function to print out the cases of the 'j' function
_print_cases() {
    local jw_default_commands
    jw_default_commands=$(sed -n '/^function just_wrapper() {/,/esac/p' $ZSH_CUSTOM/plugins/just_wrapper/just_wrapper | grep -E '^\s*[a-zA-Z_][a-zA-Z0-9_]*\)' | sed 's/)//' | tr '\n' ' ' | xargs)
    echo "$jw_default_commands $JW_SCRIPTS $JW_COMMANDS"
}

_j_completions() {
    local cur prev opts just_completions
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    # Custom options
    opts=$(_print_cases)

    # Get completions from just
    just_completions=$(just --summary 2>/dev/null)

    # Combine custom options with just completions
    combined_opts="${opts} ${just_completions}"
    combined_opts=$(echo $combined_opts | tr ' ' '\n' | sort | uniq | tr '\n' ' ')

    if [[ ${cur} == --* ]]; then
        COMPREPLY=( $(compgen -W "${combined_opts}" -- ${cur}) )
    else
        COMPREPLY=( $(compgen -W "${combined_opts}" -- ${cur}) )
    fi

    return 0
}

complete -F _j_completions just_wrapper

autoload -Uz just_wrapper