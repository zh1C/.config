# !/bin/zsh

echo "\033[33mInstalling dotfiles.\033[0m"

echo "\033[32mConfiguring zsh as default shell.\033[0m"
chsh -s $(which zsh)

if [ "$(uname)" == "Darwin" ]; then
	echo "\033[33mRunning on OSX.\033[0m"

	echo "\033[33mBrewing all the things.\033[0m"
	source ./install/brew.sh
fi

echo "\033[33mDone.\033[0m"
