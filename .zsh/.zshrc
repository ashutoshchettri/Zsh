# ~/.zshrc

#==============================================================================
# ZENITH ZSH CONFIG
#==============================================================================

#######################################################
# Instant prompt (optional, if using powerlevel10k remove this)
#######################################################

# Uncomment if needed
# [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

#######################################################
# Basic Environment
#######################################################

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export FCEDIT="nvim"
export BROWSER="com.brave.Browser"

#######################################################
# History
#######################################################

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh/.zsh_history"

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS

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

# Disable slow typo correction
unsetopt CORRECT

#######################################################
# Completion System (FAST)
#######################################################

autoload -Uz compinit

# Faster compinit using cache
if [[ ! -f ~/.zcompdump || ~/.zcompdump -nt ~/.zcompdump.zwc ]]; then
    compinit
else
    compinit -C
fi

#######################################################
# Zinit Installation
#######################################################

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

#######################################################
# Starship Prompt
#######################################################

export STARSHIP_CONFIG="$HOME/.zsh/starship/starship-gruvbox.toml"

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

#######################################################
# Plugins (ASYNC / FAST)
#######################################################

# Autosuggestions
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

# Completions
zinit ice wait lucid
zinit light zsh-users/zsh-completions

# fzf-tab
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Vi Mode
zinit ice wait lucid
zinit light jeffreytse/zsh-vi-mode

# Syntax Highlighting MUST be last
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

#######################################################
# OMZ Snippets
#######################################################

zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

#######################################################
# zsh-vi-mode Cursor Settings
#######################################################

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

#######################################################
# Keybindings
#######################################################

bindkey -v

# History search with arrows
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

#######################################################
# Completion Styling
#######################################################

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# fzf-tab previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Docker completion fixes
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

#######################################################
# bat
#######################################################

if command -v bat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export PAGER="bat"
fi

#######################################################
# fzf
#######################################################

if command -v fzf >/dev/null 2>&1; then

    export FZF_DEFAULT_OPTS="
    --height=10%
    --layout=reverse
    --border=rounded
    --info=inline-right
    --ansi
    "

    # Faster than eval "$(fzf --zsh)"
    [[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
    [[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
fi

#######################################################
# zoxide
#######################################################

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

#######################################################
# thefuck (optional, still somewhat slow)
#######################################################

if command -v thefuck >/dev/null 2>&1; then
    eval "$(thefuck --alias fk)"
fi

#######################################################
# Aliases and Functions
#######################################################

[[ -f ~/.zsh/alias.zsh ]] && source ~/.zsh/alias.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh

#######################################################
# Fastfetch (ONLY ON FIRST TERMINAL)
#######################################################

if command -v fastfetch >/dev/null 2>&1; then
    if [[ -z "$FASTFETCH_SHOWN" ]]; then
        export FASTFETCH_SHOWN=1

        if [[ -d "$HOME/.local/share/fastfetch" ]]; then
            ffconfig="ascii-art"
            fastfetch --config "$ffconfig"

            alias fastfetch="clear && fastfetch --config $ffconfig"
        else
            fastfetch
        fi
    fi
fi

#######################################################
# Replay cd hooks
#######################################################

zinit cdreplay -q

#######################################################
# Profiling (DISABLED)
#######################################################

# Uncomment for startup profiling
# zmodload zsh/zprof
# zprof

export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_HOME=$ANDROID_SDK_ROOT
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
