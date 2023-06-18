#!/bin/zsh

# Environments should be add ~/.zprofile

# Default programs
export EDITOR="nvim"

# ~/ Clean-up
export ZDOTDIR="$HOME/.config/zsh"
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST"

# ranger avoid loading both the default and my own rc.conf
export RANGER_LOAD_DEFAULT_RC="false"

# lazygit change config directory
export XDG_CONFIG_HOME="$HOME/.config"

# starship config directory
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# oh-my-zsh 
export ZSH="$HOME/.config/oh-my-zsh"

# bin/t
export PATH=$PATH:$HOME/.config/zsh/bin

# fix no UTF-8. 
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
