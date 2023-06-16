#!/bin/zsh

# Dock
echo "Automatically hide the Dock"
defaults write com.apple.dock "autohide" -bool "true"

echo "Set the icon size 60"
defaults write com.apple.dock "tilesize" -int "60"

echo "Show recents set false"
defaults write com.apple.dock "show-recents" -bool "false"

echo "Close rearrange automatically"
defaults write com.apple.dock "mru-spaces" -bool "false"

killall Dock

# Finder
echo "Open path bar"
defaults write com.apple.finder ShowPathbar -bool "true"

echo "Automatically empty bin after 30 days"
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"

killall Finder
