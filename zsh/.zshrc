# Config for the zommer shell.

# on-my-zsh config
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# ohmyzsh plugin fzf config
# export FZF_BASE="/opt/homebrew/bin/fzf"
# [ -f "$HOME/.config/zsh/fzfrc" ] && source "$HOME/.config/zsh/fzfrc"
# DISABLE_FZF_AUTO_COMPLETION="false"
# DISABLE_FZF_KEY_BINDINGS="false"

# zsh-syntax-highlighting must be the last plugin sourced.
plugins=(git 
		# fzf 
		fzf-tab
		zsh-autosuggestions 
		zsh-syntax-highlighting
		)

source $ZSH/oh-my-zsh.sh

# History in cache directory.
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete.
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files

# vi mode
bindkey -v
export KEYTIMEOUT=20

# Use jk change to normal mode.
bindkey -M viins 'jk' vi-cmd-mode

# Use vim keys in tab complete menu.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Change cursor shape for different vi mode
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
		echo -ne '\e[1 q'
	elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] ||
		 [[ ${KEYMAP} == '' ]] || [[ $1 = 'beam' ]]; then
		echo -ne '\e[5 q'
	fi
}
zle -N zle-keymap-select
zle-line-init() {
	# initiate 'vi insert' as keymap 
	# (can be removed if 'bindey -v' has been set elsewhere)
	zle -K viins  
	echo -ne "\e[5 q"
}
zle -N zle-line-init
# Use beam shape cursor on startup.
echo -ne '\e[5 q'
# Use beam shape cursor for each new prompt.
preexec() { echo -ne '\e[5 q'; }

# Edit line in vim with Ctrl-e.
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/zsh/shortcutrc" ] && source "$HOME/.config/zsh/shortcutrc"
[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"

# Load fzf config if existent.
# [ -f "$HOME/.config/zsh/fzfrc" ] && source "$HOME/.config/zsh/fzfrc"
# [ -f "$HOME/.config/zsh/.fzf.sh" ] && source "$HOME/.config/zsh/.fzf.sh"

# starship load
eval "$(starship init zsh)"

# zoxide load
eval "$(zoxide init zsh)"
