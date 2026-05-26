#!/bin/zsh

echo "\033[33mConfiguring Rime input method...\033[0m"

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

# Clone plum
clone_or_pull "https://github.com/rime/plum" "$HOME/.config/plum" "--depth=1"

# Preserve user data, only remove config files
mkdir -p "$HOME/Library/Rime"
rm -f "$HOME/Library/Rime/default.yaml"
rm -f "$HOME/Library/Rime/default.custom.yaml"
rm -f "$HOME/Library/Rime/squirrel.custom.yaml"
rm -f "$HOME/Library/Rime/rime_ice.custom.yaml"

# Install rime-ice
bash "$HOME/.config/plum/rime-install" iDvel/rime-ice:others/recipes/full

# Symlink custom configs
ln -sf "$HOME/.config/rimeconf/default.custom.yaml" "$HOME/Library/Rime/default.custom.yaml"
ln -sf "$HOME/.config/rimeconf/squirrel.custom.yaml" "$HOME/Library/Rime/squirrel.custom.yaml"
ln -sf "$HOME/.config/rimeconf/rime_ice.custom.yaml" "$HOME/Library/Rime/rime_ice.custom.yaml"

echo "\033[31mFinished Rime configurations. Don't forget to update sync_dir in installation.yml.\033[0m"
echo "\033[31mNotes: If you cannot use Rime, please log out and log back in.\033[0m"
