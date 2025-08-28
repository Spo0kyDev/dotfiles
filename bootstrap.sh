#!/usr/bin/env zsh
set -euo pipefail

log()   { print -P "%F{cyan}==>%f $*"; }
ok()    { print -P "%F{green}✓%f  $*"; }
warn()  { print -P "%F{yellow}!%f  $*"; }
fail()  { print -P "%F{red}✗%f  $*"; exit 1; }

REPO_SSH="git@github.com:Spo0kyDev/dotfiles.git"
DOTDIR="$HOME/dotfiles"

log "Bootstrapping dotfiles for $USER"

# Ensure git is available
command -v git >/dev/null 2>&1 || fail "git not found. Install git and re-run."

# Clone repo if missing
if [ ! -d "$DOTDIR/.git" ]; then
  log "Cloning $REPO_SSH into $DOTDIR"
  git clone "$REPO_SSH" "$DOTDIR"
else
  log "Dotfiles repo exists. Pulling latest..."
  git -C "$DOTDIR" pull --ff-only || warn "Could not pull latest (skipping)."
fi

cd "$DOTDIR"

# Symlinks
log "Linking configuration files"
ln -sf "$DOTDIR/.zshrc"     "$HOME/.zshrc"
[ -f "$DOTDIR/.vimrc" ]     && ln -sf "$DOTDIR/.vimrc"     "$HOME/.vimrc"
[ -f "$DOTDIR/.dircolors" ] && ln -sf "$DOTDIR/.dircolors" "$HOME/.dircolors"
ok "Symlinks updated"

# Vim: install Gruvbox colorscheme
log "Ensuring Gruvbox for Vim is installed"
mkdir -p "$HOME/.vim/colors"
GRUV_DST="$HOME/.vim/colors/gruvbox.vim"
if [ ! -f "$GRUV_DST" ]; then
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim -o "$GRUV_DST"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$GRUV_DST" https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim
  else
    warn "Neither curl nor wget found; skipping Gruvbox download."
  fi
  [ -f "$GRUV_DST" ] && ok "Gruvbox installed" || warn "Gruvbox not installed"
else
  ok "Gruvbox already present"
fi

print
ok "Bootstrap complete"
print -P "%F{yellow}Note:%f Open a new zsh session or run 'exec zsh' to load .zshrc"

