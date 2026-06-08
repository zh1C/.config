#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "\033[33mConfiguring shell environment...\033[0m"

# Set zsh as default shell
if [[ "$SHELL" != */zsh ]]; then
    chsh -s "$(which zsh)"
fi

# Add environments to .zprofile
if [[ ! -e "$HOME/.zprofile" ]]; then
    touch "$HOME/.zprofile"
fi
if ! grep -q 'source "$HOME/.config/zsh/env.sh"' "$HOME/.zprofile" 2>/dev/null; then
    echo '\n#adding environments from env.sh.\nsource "$HOME/.config/zsh/env.sh"' >> "$HOME/.zprofile"
fi

mkdir -p "$HOME/.cache/zsh"

# oh-my-zsh
if [[ -z "$ZSH" ]]; then
    export ZSH="$HOME/.config/oh-my-zsh"
fi

RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# oh-my-zsh plugins
export ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"

clone_or_pull() {
    local repo=$1
    local dest=$2
    local opts=$3
    if [[ -d "$dest/.git" ]]; then
        git -C "$dest" pull
    elif [[ -d "$dest" ]]; then
        rm -rf "$dest"
        git clone $opts "$repo" "$dest"
    else
        git clone $opts "$repo" "$dest"
    fi
}

clone_or_pull "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull "https://github.com/Aloxaf/fzf-tab" "$ZSH_CUSTOM/plugins/fzf-tab"

echo "\033[32mShell environment configured.\033[0m"
