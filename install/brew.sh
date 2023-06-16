#!/bin/zsh

which brew &>/dev/null

if [[ $? != 0 ]]; then 
    echo "\033[32mInstalling homebrew\033[0m"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> $HOME/.zprofile
fi

if [[ $EDITOR == "" ]]; then
	echo '\n#Default programs\nexport EDITOR="nvim"' >> $HOME/.zprofile
	echo "\033[32mAdded EDITOR environment.\033[0m"
fi

echo "\033[33mInstalling homebrew packages...\033[0m"

# devlop
brew install bat
brew install exa
brew install fd
brew install fzf
brew install highlight
brew install jq
brew install lazygit
brew install ripgrep
brew install ranger
brew install starship
brew install zoxide

# ranger avoid loading both the default and my own rc.conf
if [[ $RANGER_LOAD_DEFAULT_RC == "" ]]; then
	echo '\n# ranger avoid loading both the default and my own rc.conf
export RANGER_LOAD_DEFAULT_RC="false"' >> $HOME/.zprofile
	echo "\033[32mAdded RANGER_LOAD_DEFAULT_RC environment.\033[0m"
fi

# add XDG_CONFIG_HOME
if [[ $XDG_CONFIG_HOME == "" ]]; then
	echo '\nexport XDG_CONFIG_HOME="$HOME/.config"' >> $HOME/.zprofile
	echo "\033[32mAdded XDG_CONFIG_HOME environment.\033[0m"
fi

# add STARSHIP_CONFIG
if [[ $STARSHIP_CONFIG == "" ]]; then
	echo '\n# STARSHIP_CONFIG
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"' >> $HOME/.zprofile
	echo "\033[32mAdded STARSHIP_CONFIG environment.\033[0m"
fi

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
valid_installed "exa"
valid_installed "fd"
valid_installed "fzf"
valid_installed "highlight"
valid_installed "jq"
valid_installed "lazygit"
valid_installed "rg"
valid_installed "ranger"
valid_installed "starship"
valid_installed "zoxide"


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
brew install --cask stats
brew install --cask raycast
brew install --cask visual-studio-code
brew install --cask spotify

valid_installed "alacritty"

# tmux
brew install tmux

valid_installed "tmux"

git clone https://github.com/gpakosz/.tmux.git "$HOME/.config/tmux/.tmux"

if [[ ! -e "$XDG_CONFIG_HOME/tmux/tmux.conf" ]]; then
	ln -s "$HOME/.config/tmux/.tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"
	echo "\033[32mCreate tmux.conf\033[0m"
fi

if [[ ! -e "$XDG_CONFIG_HOME/tmux/tmux.conf.local" ]]; then
	cp "$HOME/.config/tmux/.tmux/.tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"
	echo "\033[32mCreate tmux.conf.local\033[0m"
fi

# zsh
if [[ $ZDOTDIR == "" ]]; then
	echo '\n# ~/ Clean up\nexport ZDOTDIR="$HOME/.config/zsh"' >> $HOME/.zprofile
	echo 'export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST"' >> $HOME/.zprofile
	echo "\033[32mAdded ZDOTDIR and ZSH_COMPDUMP environment.\033[0m"
fi

if [[ $ZSH == "" ]]; then
	echo '\n# ZSH\nexport ZSH="$HOME/.config/oh-my-zsh"' >> $HOME/.zprofile
	echo '\nexport PATH=$PATH:$HOME/.config/zsh/bin' >> $HOME/.zprofile
	echo "\033[32mAdded ZSH environment.\033[0m"
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install ohmyzsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
