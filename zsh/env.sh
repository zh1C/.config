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

# fix no UTF-8. btop
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# zoxide database path
export _ZO_DATA_DIR="$HOME/.config/zsh/zoxide"

# mcfly environments.
# By default Mcfly uses an emacs inspired key scheme.
export MCFLY_KEY_SCHEME=vim
# To enable fuzzy searching, set MCFLY_FUZZY to an integer. 0 is off;
# higher numbers weight toward shorter matches. Values in the 2-5 range get good results so far.
export MCFLY_FUZZY=2
export MCFLY_RESULTS=10
export MCFLY_PROMPT="❯"
export MCFLY_HISTORY_LIMIT=10000
