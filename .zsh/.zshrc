#==============================================================================
# ZENITH ZSH CONFIG - MINIMAL CATPPUCCIN
#==============================================================================

#######################################################
# Basic Environment & Android SDK
#######################################################
export EDITOR="nvim"
export VISUAL="nvim"

# Android SDK Configuration
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools"
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

#######################################################
# History
#######################################################
[[ -d "$HOME/.zsh" ]] || mkdir -p "$HOME/.zsh"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh/.zsh_history"

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS

#######################################################
# ZSH Options
#######################################################
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt MAGIC_EQUAL_SUBST
setopt NO_NOMATCH
setopt NOTIFY
setopt NUMERIC_GLOB_SORT
setopt PROMPT_SUBST
unsetopt CORRECT

#######################################################
# Completion System
#######################################################
autoload -Uz compinit
if [[ ! -f ~/.zcompdump || ~/.zcompdump -nt ~/.zcompdump.zwc ]]; then
    compinit
else
    compinit -C
fi

#######################################################
# Zinit & Plugins
#######################################################
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && mkdir -p "$(dirname "$ZINIT_HOME")" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting

zinit snippet OMZP::sudo
zinit snippet OMZP::git

#######################################################
# Keybindings & Cursor
#######################################################
bindkey -v

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

function zvm_after_init() {
  zvm_cursor_blink
}

zvm_cursor_blink() {
  echo -ne "\e[5 q"
}
precmd_functions+=(zvm_cursor_blink)

#######################################################
# External Tools
#######################################################
# Starship
export STARSHIP_CONFIG="$HOME/.zsh/starship/starship.toml"
[[ -f $(which starship) ]] && eval "$(starship init zsh)"

# Zoxide
[[ -f $(which zoxide) ]] && eval "$(zoxide init zsh)"

# FZF Settings
if [[ -f $(which fzf) ]]; then
    export FZF_DEFAULT_OPTS="--height=15% --layout=reverse --border=rounded --info=inline-right --ansi"
    [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
    [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
fi

#######################################################
# Aliases & Fastfetch
#######################################################
[[ -f ~/.zsh/alias.zsh ]] && source ~/.zsh/alias.zsh

if [[ -z "$FASTFETCH_SHOWN" && -f $(which fastfetch) ]]; then
    export FASTFETCH_SHOWN=1
    fastfetch
fi
