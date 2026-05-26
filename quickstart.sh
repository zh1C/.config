#!/bin/zsh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "\033[33mInstalling dotfiles.\033[0m"

echo "\033[32mConfiguring zsh as default shell.\033[0m"
chsh -s $(which zsh)

if [ "$(uname)" == "Darwin" ]; then
	echo "\033[33mRunning on OSX.\033[0m"

	echo "\033[33mAdding environments.\033[0m"
	if [[ ! -e "$HOME/.zprofile" ]]; then
		touch "$HOME/.zprofile"
		echo "\033[32mCreate .zprofile file.\033[0m"
	fi
	if ! grep -q 'source "$HOME/.config/zsh/env.sh"' "$HOME/.zprofile" 2>/dev/null; then
		echo '\n#adding environments from env.sh.\nsource "$HOME/.config/zsh/env.sh"' >> "$HOME/.zprofile"
	fi
	source "$HOME/.zprofile"

	echo "\033[33mBrewing all the things.\033[0m"
	source "$SCRIPT_DIR/install/brew.sh"

	echo "\033[33mUpdating OSX settings.\033[0m"
	source "$SCRIPT_DIR/install/osx.sh"
fi

echo "\033[33mDone.\033[0m"
