#!/bin/zsh

which brew &>/dev/null

if [[ $? != 0 ]]; then 
    echo "\033[32mInstalling homebrew\033[0m"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> $HOME/.zprofile
fi

echo "\033[33mInstalling homebrew packages...\033[0m"

# devlop
brew install bat
brew install exa
brew install fd
brew install fzf
brew install highlight
brew install jq
brew install jesseduffield/lazygit/lazygit
brew install neovim
brew install ripgrep
brew install ranger
brew install starship
brew install zoxide
brew install cantino/mcfly/mcfly

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
valid_installed "nvim"
valid_installed "rg"
valid_installed "ranger"
valid_installed "starship"
valid_installed "zoxide"

# neovim
if [[ ! -d "$HOME/.config/nvim" ]]; then
	mkdir "$HOME/.config/nvim"
fi

# clone nvim configurations
git clone git@github.com:zh1C/neovim-config.git "$HOME/.config/nvim"


# ranger plugins
echo "\033[32mInstalling ranger plugins.\033[0m"
git clone https://github.com/prateekpunetha/ranger_devicons.git "$HOME/.config/ranger/plugins/ranger_devicons"
git clone git@github.com:jchook/ranger-zoxide.git "$HOME/.config/ranger/plugins/zoxide"
git clone git@github.com:MuXiu1997/ranger-fzf-filter.git "$HOME/.config/ranger/plugins/ranger_fzf_filter"

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
brew tap homebrew/cask-fonts && brew install font-lxgw-wenkai
brew install --cask stats
brew install --cask raycast
brew install --cask visual-studio-code
brew install --cask spotify
brew install --cask squirrel
brew install --cask obsidian

valid_installed "alacritty"

echo "\033[33mStart Rime configuration.\033[0m"

echo "\033[32mClone plum.\033[0m"
git clone --depth=1 https://github.com/rime/plum "$HOME/.config/plum"

echo "\033[32mRemove Rime default configurations.\033[0m"

if [[ -d "$HOME/Library/Rime" ]]; then 
	rm -rf "$HOME/Library/Rime"
	mkdir "$HOME/Library/Rime"
fi

echo "\033[32mInstall rime-ice.\033[0m"
bash $HOME/.config/plum/rime-install iDvel/rime-ice:others/recipes/full

# Create soft link
if [[ -f "$HOME/Library/Rime/default.custom.yaml" ]]; then
	rm -f "$HOME/Library/Rime/default.custom.yaml"
	ln -s "$HOME/.config/rimeconf/default.custom.yaml" "$HOME/Library/Rime/default.custom.yaml"
fi

if [[ -f "$HOME/Library/Rime/squirrel.custom.yaml" ]]; then
	rm -f "$HOME/Library/Rime/squirrel.custom.yaml"
	ln -s "$HOME/.config/rimeconf/squirrel.custom.yaml" "$HOME/Library/Rime/squirrel.custom.yaml"
fi

if [[ -f "$HOME/Library/Rime/rime_ice.custom.yaml" ]]; then
	rm -f "$HOME/Library/Rime/rime_ice.custom.yaml"
	ln -s "$HOME/.config/rimeconf/rime_ice.custom.yaml" "$HOME/Library/Rime/rime_ice.custom.yaml"
fi

echo "\033[31mFinished Rime configurations. Don't forget to update sync_dir in installation.yml.\033[0m"
echo "\033[31mNotes:If you cannot use Rime, please log out.\033[0m"

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

# ohmyzsh
if [[ $ZSH == "" ]]; then
	export ZSH="$HOME/.config/oh-my-zsh"
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install ohmyzsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
