# ============================================================================
# .bashrc — alias and colors 
# ============================================================================

# Only run in interactive shells
[[ $- != *i* ]] && return

# --- Enable color support for ls (uses system defaults) ---
if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b 2>/dev/null || true)"
fi

alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'

# --- Git helpers ---
alias gs='git status'
alias gl='git log --oneline --decorate --graph -n 15'
alias gd='git diff'

# --- Show current git branch in prompt (lightweight) ---
parse_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# --- Prompt ---
# Green: user@host
# Blue: current directory
# Yellow: git branch (if any)
PS1='\[\e[1;32m\]\u@\h \[\e[1;34m\]\w/\[\e[0m\] \[\e[1;33m\]$(parse_git_branch)\[\e[0m\] \$ '

# --- History improvements ---
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export HISTFILESIZE=10000
shopt -s histappend

# --- Better tab completion behavior ---
bind 'set completion-ignore-case on'
