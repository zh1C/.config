#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "\033[33mInstalling dotfiles...\033[0m"

if [ "$(uname)" != "Darwin" ]; then
    echo "\033[31mThis dotfiles repo is macOS only.\033[0m"
    exit 1
fi

source "$SCRIPT_DIR/brew.sh"
source "$SCRIPT_DIR/shell.sh"
source "$SCRIPT_DIR/link.sh"
source "$SCRIPT_DIR/rime.sh"
source "$SCRIPT_DI/osx.sh"
source "$SCRIPT_DI/service.sh"

echo "\033[33mDone. Post-install steps:\033[0m"
echo "  1. Run 'upyabai' to update yabai sudoers hash"
echo "  2. Update sync_dir in ~/Library/Rime/installation.yml"
echo "  3. Log out and back in if Rime doesn't work"
