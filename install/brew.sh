#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v brew &>/dev/null; then
    echo "\033[32mInstalling Homebrew...\033[0m"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    if ! grep -q 'eval $(/opt/homebrew/bin/brew shellenv)' "$HOME/.zprofile" 2>/dev/null; then
        echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> "$HOME/.zprofile"
    fi
fi

echo "\033[33mInstalling packages from Brewfile...\033[0m"
brew bundle --file="$SCRIPT_DIR/Brewfile"

echo "\033[32mBrew packages installed.\033[0m"
