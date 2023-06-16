#!/bin/zsh

# Dock
echo "\033[32mSet Dock.\033[0m"

echo "Automatically hide the Dock"
defaults write com.apple.dock "autohide" -bool "true"

echo "Set the icon size 60"
defaults write com.apple.dock "tilesize" -int "60"

echo "Show recents set false"
defaults write com.apple.dock "show-recents" -bool "false"

echo "Close rearrange automatically"
defaults write com.apple.dock "mru-spaces" -bool "false"
