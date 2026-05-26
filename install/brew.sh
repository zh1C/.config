#!/bin/zsh

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

which brew &>/dev/null

if [[ $? != 0 ]]; then
    echo "\033[32mInstalling homebrew\033[0m"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
	if ! grep -q 'eval $(/opt/homebrew/bin/brew shellenv)' "$HOME/.zprofile" 2>/dev/null; then
		echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> $HOME/.zprofile
	fi
fi

echo "\033[33mInstalling homebrew packages...\033[0m"

# devlop
brew install atool
brew install bat
brew install btop
brew install eza
brew install fd
brew install fzf
brew install highlight
brew install jq
brew install jesseduffield/lazygit/lazygit
brew install neovim
brew install ripgrep
brew install yazi ffmpegthumbnailer poppler
brew install git-delta
brew install starship
brew install neofetch
brew install zoxide
brew install jenv
brew install pyenv
brew tap cantino/mcfly && brew install cantino/mcfly/mcfly
brew install telnet

valid_installed() {
	local util
	util=$1
	which $util &>/dev/null
	if [[ $? != 0 ]]; then
		echo "\033[31m$util install failed.\033[0m"
	else
		echo "\033[32m$util installed successfully.\033[0m"
	fi
}

valid_installed "bat"
valid_installed "btop"
valid_installed "eza"
valid_installed "fd"
valid_installed "fzf"
valid_installed "highlight"
valid_installed "jq"
valid_installed "lazygit"
valid_installed "nvim"
valid_installed "rg"
valid_installed "yazi"
valid_installed "starship"
valid_installed "neofetch"
valid_installed "zoxide"
valid_installed "telnet"

# clone nvim configurations
if [[ -d "$HOME/.config/nvim/.git" ]]; then
	echo "\033[32mnvim config already exists, pulling latest...\033[0m"
	git -C "$HOME/.config/nvim" pull
elif [[ ! -d "$HOME/.config/nvim" ]]; then
	git clone https://github.com/zh1C/neovim-config.git "$HOME/.config/nvim"
else
	rm -rf "$HOME/.config/nvim"
	git clone https://github.com/zh1C/neovim-config.git "$HOME/.config/nvim"
fi


# yazi plugins
echo "\033[32mInstalling yazi plugins.\033[0m"
ya pack -i

# macos util
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

valid_installed "yabai"
valid_installed "skhd"

launch_service() {
	local service
	service=$1
	launchctl list | grep $service &>/dev/null
	if [[ $? != 0 ]]; then
		$service --start-service
		echo "\033[34mStart yabai service.\033[0m"
	else
		echo "\033[34mRestart yabai service.\033[0m"
		$service --restart-service
	fi
}

# start services
launch_service "yabai"
launch_service "skhd"

# cask
brew install --cask alacritty
brew install --cask font-hack-nerd-font
brew install --cask font-lxgw-wenkai
brew install --cask stats
brew install --cask raycast
brew install --cask visual-studio-code
brew install --cask spotify
brew install --cask squirrel
brew install --cask obsidian

valid_installed "alacritty"

echo "\033[33mStart Rime configuration.\033[0m"

echo "\033[32mClone plum.\033[0m"
clone_or_pull "https://github.com/rime/plum" "$HOME/.config/plum" "--depth=1"

echo "\033[32mRemove Rime default configurations.\033[0m"

rm -rf "$HOME/Library/Rime"
mkdir -p "$HOME/Library/Rime"

echo "\033[32mInstall rime-ice.\033[0m"
bash $HOME/.config/plum/rime-install iDvel/rime-ice:others/recipes/full

# Create soft link
rm -f "$HOME/Library/Rime/default.custom.yaml"
ln -s "$HOME/.config/rimeconf/default.custom.yaml" "$HOME/Library/Rime/default.custom.yaml"

rm -f "$HOME/Library/Rime/squirrel.custom.yaml"
ln -s "$HOME/.config/rimeconf/squirrel.custom.yaml" "$HOME/Library/Rime/squirrel.custom.yaml"

rm -f "$HOME/Library/Rime/rime_ice.custom.yaml"
ln -s "$HOME/.config/rimeconf/rime_ice.custom.yaml" "$HOME/Library/Rime/rime_ice.custom.yaml"

echo "\033[31mFinished Rime configurations. Don't forget to update sync_dir in installation.yml.\033[0m"
echo "\033[31mNotes:If you cannot use Rime, please log out.\033[0m"

# tmux
brew install tmux

valid_installed "tmux"

clone_or_pull "https://github.com/gpakosz/.tmux.git" "$HOME/.config/tmux/.tmux"

if [[ ! -e "$HOME/.config/tmux/tmux.conf" ]]; then
	ln -s "$HOME/.config/tmux/.tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
	echo "\033[32mCreate tmux.conf\033[0m"
fi

if [[ ! -e "$HOME/.config/tmux/tmux.conf.local" ]]; then
	cp "$HOME/.config/tmux/.tmux/.tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"
	echo "\033[32mCreate tmux.conf.local\033[0m"
fi

# ohmyzsh
if [[ $ZSH == "" ]]; then
	export ZSH="$HOME/.config/oh-my-zsh"
fi

RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# install ohmyzsh plugins
export ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"
clone_or_pull "https://github.com/zsh-users/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull "https://github.com/Aloxaf/fzf-tab" "$ZSH_CUSTOM/plugins/fzf-tab"
