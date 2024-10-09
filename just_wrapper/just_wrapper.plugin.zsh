JW_COMMANDS_DIR="$ZSH_CUSTOM/plugins/just_wrapper/commands"
JW_COMMANDS_FILE="$JW_COMMANDS_DIR/.commands"

JW_COMMANDS=$(grep -E '^function[[:space:]]+[a-zA-Z0-9_]+\(\)' "$JW_COMMANDS_FILE" | sed -E 's/^function[[:space:]]+([a-zA-Z0-9_]+)\(\).*/\1/')
JW_SCRIPTS=$(ls "$JW_COMMANDS_DIR" | grep -v '.commands' | sed 's/\.sh//')


function just_wrapper() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: just_wrapper <command> [args]"
        return 1
    fi

    case $1 in
        # Default commands provided by just_wrapper plugin
        just_wrapper_edit)
            echo "Opening VS Code in the just_wrapper commands directory..."
            code "$JW_COMMANDS_DIR"
            ;;
        just_wrapper_reload)
            echo "Reloading the shell..."
            exec $SHELL
            ;;
        just_wrapper_update)
            echo "Updating just_wrapper..."
            bash <(curl -s https://raw.githubusercontent.com/swils23/just_wrapper/main/install_script.sh) $ZSH_CUSTOM
            echo "Reloading the shell..."
            echo "Done!"
            ;;
        *)
            if [[ ! -f "$JW_COMMANDS_FILE" ]]; then
                echo "WARN: '.commands' file not found in '$JW_COMMANDS_DIR'. Falling back to Just.
                        Disable just_wrapper or add an empty file to suppress this message 'touch $JW_COMMANDS_FILE'"
                just "$@"
                return
            fi
            if [[ ! -d "$JW_COMMANDS_DIR" ]]; then
                echo "WARN: 'commands' directory not found in '$JW_COMMANDS_DIR'. Falling back to Just.
                        Disable just_wrapper or create the directory to suppress this message 'mkdir -p $JW_COMMANDS_DIR'"
                just "$@"
                return
            fi
            # Command overrides
            if echo "$JW_COMMANDS" | grep -qw "$1"; then
                "$JW_COMMANDS_FILE" "$@"
            # Script overrides
            elif script_name="$JW_COMMANDS_DIR/$1.sh"; [[ -x "$script_name" ]] || script_name="$JW_COMMANDS_DIR/$1"; [[ -x "$script_name" ]]; then
                chmod +x "$script_name"
                "$script_name" "${@:2}"
            # Fallback to just
            else
                # Make sure just is installed
                if ! command -v just &> /dev/null; then
                    echo "Just is not installed and no custom command was found for '$1'"
                    return 1
                fi
                just "$@"
            fi
            ;;
    esac
}

# region completion
_print_cases() {
    local jw_default_commands
    jw_default_commands=$(sed -n '/^function just_wrapper() {/,/esac/p' $ZSH_CUSTOM/plugins/just_wrapper/just_wrapper.plugin.zsh | grep -E '^\s*[a-zA-Z_][a-zA-Z0-9_]*\)' | sed 's/)//' | tr '\n' ' ' | xargs)
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
# endregion completion