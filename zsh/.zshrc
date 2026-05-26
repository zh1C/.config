# Config for the zommer shell.

# on-my-zsh config
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/oh-my-zsh"
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# ohmyzsh plugin fzf config
# export FZF_BASE="/opt/homebrew/bin/fzf"
# [ -f "$HOME/.config/zsh/fzfrc" ] && source "$HOME/.config/zsh/fzfrc"
# DISABLE_FZF_AUTO_COMPLETION="false"
# DISABLE_FZF_KEY_BINDINGS="false"

# Skip aliases
# Skip only aliases defined in the directories.zsh lib file
zstyle ':omz:lib:directories' aliases no

# zsh-syntax-highlighting must be the last plugin sourced.
plugins=(git
		# fzf
		# vi-mode
		macos
		fzf-tab
		zsh-autosuggestions
		zsh-syntax-highlighting
		)

zstyle ':completion:*' menu select
zmodload zsh/complist

source $ZSH/oh-my-zsh.sh

_comp_options+=(globdots)

# History in cache directory.
[[ -d ~/.cache/zsh ]] || mkdir -p ~/.cache/zsh
HISTSIZE=30000
SAVEHIST=30000
HISTFILE=~/.cache/zsh/history

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

# yazi file manager
# use y replase yazi to start
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/zsh/shortcutsrc" ] && source "$HOME/.config/zsh/shortcutsrc"
[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"

# Load fzf config if existent.
# [ -f "$HOME/.config/zsh/fzfrc" ] && source "$HOME/.config/zsh/fzfrc"
# [ -f "$HOME/.config/zsh/.fzf.sh" ] && source "$HOME/.config/zsh/.fzf.sh"

# nvm loads
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# starship load
command -v starship &>/dev/null && eval "$(starship init zsh)"

# zoxide load
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# mcfly load
command -v mcfly &>/dev/null && eval "$(mcfly init zsh)"

# disable brew auto update
export HOMEBREW_NO_AUTO_UPDATE=1

# Start neofetch when open the terminal.
# neofetch

# pyenv
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    pyenv commands | grep -q virtualenv-init && eval "$(pyenv virtualenv-init -)"
fi

# go env
# eval "$(goenv init -)"

# jenv
command -v jenv &>/dev/null && eval "$(jenv init -)"

command -v thefuck &>/dev/null && eval $(thefuck --alias)

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
