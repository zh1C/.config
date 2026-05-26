#!/bin/zsh

echo "\033[33mLinking configurations...\033[0m"

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

# neovim
clone_or_pull "https://github.com/zh1C/neovim-config.git" "$HOME/.config/nvim"

# yazi plugins
if command -v ya &>/dev/null; then
    echo "\033[32mInstalling yazi plugins.\033[0m"
    ya pack -i
fi

# tmux
clone_or_pull "https://github.com/gpakosz/.tmux.git" "$HOME/.config/tmux/.tmux"

if [[ ! -e "$HOME/.config/tmux/tmux.conf" ]]; then
    ln -s "$HOME/.config/tmux/.tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
    echo "\033[32mCreated tmux.conf symlink.\033[0m"
fi

echo "\033[32mConfigurations linked.\033[0m"
