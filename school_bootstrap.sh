#!/usr/bin/env bash
# school_bootstrap.sh — user-level setup for Fox servers
set -euo pipefail

# ---- logging ----
log(){ printf "\033[36m==>\033[0m %s\n" "$*"; }
ok(){  printf "\033[32m✓ \033[0m %s\n" "$*"; }
warn(){printf "\033[33m! \033[0m %s\n" "$*"; }

# ---- paths ----
DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.school_bootstrap_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"

# ---- helpers ----
have(){ command -v "$1" >/dev/null 2>&1; }
fetch(){
  # fetch URL -> dest
  local url="$1" dest="$2"
  if have curl; then curl -fsSL "$url" -o "$dest"
  elif have wget; then wget -qO "$dest" "$url"
  else return 1
  fi
}

# ---- 1) Vim + Gruvbox (user-level) ----
log "Installing Gruvbox for Vim (user)"
mkdir -p "$HOME/.vim/colors"
if [ ! -f "$HOME/.vim/colors/gruvbox.vim" ]; then
  if fetch "https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim" "$HOME/.vim/colors/gruvbox.vim"; then
    ok "Gruvbox installed to ~/.vim/colors"
  else
    warn "Could not download gruvbox (no curl/wget?)"
  fi
else
  ok "Gruvbox already present"
fi

# ---- 2) dircolors (prefer repo version) ----
log "Configuring dircolors"
if [ -f "$DOTDIR/.dircolors" ]; then
  # symlink if possible; fall back to copy
  if ln -sfn "$DOTDIR/.dircolors" "$HOME/.dircolors" 2>/dev/null; then
    ok "Linked ~/.dircolors -> repo version"
  else
    cp -f "$DOTDIR/.dircolors" "$HOME/.dircolors"
    ok "Copied ~/.dircolors from repo"
  fi
else
  warn "Repo .dircolors not found; will use system defaults if available"
fi

# Lines to enable dircolors in shells
read -r -d '' DIRC_SNIPPET <<'EOS' || true
# --- dircolors (user) ---
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b "$HOME/.dircolors" 2>/dev/null || dircolors -b)"
  # GNU ls color
  if ls --version >/dev/null 2>&1; then
    alias ls='ls --color=auto'
    alias ll='ls -alF'
  fi
fi
# Load local aliases (not in repo; safe place for secrets)
[ -f "$HOME/.aliases.local" ] && . "$HOME/.aliases.local"
# ------------------------
EOS

# ---- 3) Bash config (append idempotently) ----
log "Updating ~/.bashrc"
[ -f "$HOME/.bashrc" ] && cp -f "$HOME/.bashrc" "$BACKUP/.bashrc.bak" || true
grep -q "dircolors (user)" "$HOME/.bashrc" 2>/dev/null || printf "\n%s\n" "$DIRC_SNIPPET" >> "$HOME/.bashrc"
ok "~/.bashrc updated (backup in $BACKUP)"

# ---- 4) Zsh config (create or append safely) ----
log "Updating ~/.zshrc"
[ -f "$HOME/.zshrc" ] && cp -f "$HOME/.zshrc" "$BACKUP/.zshrc.bak" || true

# Minimal, safe Zsh starter that won’t error if OMZ is absent
read -r -d '' ZSH_BASE <<'EOS' || true
# --- minimal zsh base ---
setopt AUTO_CD
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Safe Oh-My-Zsh loader (optional)
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
if [ -d "$ZSH" ] && [ -f "$ZSH/oh-my-zsh.sh" ]; then
  plugins=(git)
  : ${ZSH_THEME:=robbyrussell}
  source "$ZSH/oh-my-zsh.sh"
fi
# ------------------------
EOS

# Ensure file exists and contains base + dircolors block (idempotent)
touch "$HOME/.zshrc"
grep -q "minimal zsh base" "$HOME/.zshrc" 2>/dev/null || printf "%s\n\n" "$ZSH_BASE" >> "$HOME/.zshrc"
grep -q "dircolors (user)" "$HOME/.zshrc" 2>/dev/null || printf "%s\n" "$DIRC_SNIPPET" >> "$HOME/.zshrc"
ok "~/.zshrc updated (backup in $BACKUP)"

# ---- 5) Friendly notes ----
echo
ok "School setup complete."
echo "Backups saved in: $BACKUP"
echo "Notes:"
echo "  - Start zsh now:   exec zsh"
echo "  - Put school-only aliases (e.g., fox01) in ~/.aliases.local (not in Git)."
echo "    Example:"
echo "      echo \"alias fox01='ssh qcr754@10.100.240.201'\" >> ~/.aliases.local"
echo "  - Repo can be removed after setup: rm -rf ~/dotfiles (configs stay)."
