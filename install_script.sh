# Installs just_wrapper plugin for Oh My Zsh

# $ZSH_CUSTOM is passed as an arg to this script since it is not available in the environment
if [ -z "$1" ]; then
    echo "Error: ZSH_CUSTOM directory not provided"
    exit 1
fi

ZSH_CUSTOM=$1

DOWNLOAD_LOCATION="https://github.com/swils23/just_wrapper/archive/main.zip"
CUSTOM_PLUGIN_DIR="$ZSH_CUSTOM/plugins/"

# Temporary directory for installation
current_dir=$(pwd)
mkdir -p /tmp/just_wrapper_install
cd /tmp/just_wrapper_install

# Download and extract the plugin
curl -LOks $DOWNLOAD_LOCATION -o main.zip
unzip -q main.zip
rm main.zip

# Clean Install
if [ ! -d "$CUSTOM_PLUGIN_DIR/just_wrapper" ]; then
    mkdir -p $CUSTOM_PLUGIN_DIR/just_wrapper
    mv just_wrapper-main/just_wrapper/* $CUSTOM_PLUGIN_DIR/just_wrapper
    chmod +x "$CUSTOM_PLUGIN_DIR/just_wrapper/commands/.commands"
# Update while preserving user changes
else
    mv just_wrapper-main/just_wrapper/just_wrapper.plugin.zsh $CUSTOM_PLUGIN_DIR/just_wrapper
fi

# Post-installation cleanup
cd $current_dir
rm -rf /tmp/just_wrapper_install

echo "*Important* Make sure to add 'just_wrapper' to plugins in '.zshrc' and reload the shell"
