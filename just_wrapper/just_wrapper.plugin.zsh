JW_COMMANDS_DIR="$ZSH_CUSTOM/plugins/just_wrapper/commands/"
JW_COMMANDS_FILE="$JW_COMMANDS_DIR/.commands"
chmod +x "$JW_COMMANDS_DIR"/*

JW_COMMANDS=$(awk '/^function/ {print $2}' "$JW_COMMANDS_FILE" | sed -E 's/\(\)//' | sed 's/{//')
JW_SCRIPTS=$(ls "$JW_COMMANDS_DIR" | grep -v '.commands' | sed 's/\.sh//')


function just_wrapper() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: just_wrapper <command> [args]"
        return 1
    fi

    case $1 in
        # Default commands provided by just_wrapper plugin
        just_wrapper_edit)
            code "$JW_COMMANDS_DIR"
            ;;
        just_wrapper_reload)
            exec $SHELL
            ;;
        just_wrapper_update)
            bash <(curl -s https://raw.githubusercontent.com/swils23/just_wrapper/main/install_script) $ZSH_CUSTOM
            ;;
        *)
            # Command overrides
            if echo "$JW_COMMANDS" | grep -qw "$1"; then
                "$JW_COMMANDS_FILE" "$@"
            # Script overrides
            elif echo "$JW_SCRIPTS" | grep -qw "$1"; then
                "$JW_COMMANDS_DIR/$1" "${@:2}"
            # Fallback to just
            else
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