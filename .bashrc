# ============================================================================
# .bashrc — aliases and colors (portable, minimal)
# ============================================================================

# Only run in interactive shells
[[ $- != *i* ]] && return

# ---------------------------------------------------------------------------
# Color support
# ---------------------------------------------------------------------------
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b 2>/dev/null || true)"
fi

alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git
alias gs='git status'
alias gl='git log --oneline --decorate --graph -n 15'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'

# Quick edits
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias reload='source ~/.bashrc'

# ---------------------------------------------------------------------------
# Git branch display in prompt
# ---------------------------------------------------------------------------
parse_git_branch() {
    local b
    b="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || return 0
    [[ -n "$b" && "$b" != "HEAD" ]] && printf " (%s)" "$b"
}

# ---------------------------------------------------------------------------
# Prompt
# Green: user@host
# Blue: current directory
# Yellow: git branch (if any)
# ---------------------------------------------------------------------------
PS1='\[\e[1;32m\]\u@\h:\[\e[1;34m\]\w\[\e[0m\]\[\e[1;33m\]$(parse_git_branch)\[\e[0m\] \$ '

# ---------------------------------------------------------------------------
# History improvements
# ---------------------------------------------------------------------------
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export HISTFILESIZE=10000
shopt -s histappend

# ---------------------------------------------------------------------------
# Better tab completion
# ---------------------------------------------------------------------------
bind 'set completion-ignore-case on'
