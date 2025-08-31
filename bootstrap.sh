#!/usr/bin/env zsh
set -euo pipefail

# ---------- logging ----------
log()  { print -P "%F{cyan}==>%f $*"; }
ok()   { print -P "%F{green}✓%f  $*"; }
warn() { print -P "%F{yellow}!%f  $*"; }
fail() { print -P "%F{red}✗%f  $*"; exit 1; }

# ---------- config ----------
# Use HTTPS so cloning/pulling public repos never prompts.
# Change the URL/owner if needed.
REPO_URL="https://github.com/Spo0kyDev/dotfiles.git"
DOTDIR="${DOTDIR:-$HOME/dotfiles}"
BACKUP="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Files/dirs in the repo to link into $HOME
LINKS=(
  ".zshrc"
  ".vimrc"
  ".dircolors"
  # add more as you wish, e.g. ".config/nvim"
)

INSTALL_OMZ=${INSTALL_OMZ:-1}         # 1=install Oh-My-Zsh if missing; 0=skip
INSTALL_P10K=${INSTALL_P10K:-0}       # 1=install Powerlevel10k if OMZ present

# ---------- prereqs ----------
command -v git  >/dev/null 2>&1 || fail "git not found. Install git and re-run."
command -v curl >/dev/null 2>&1 || command -v wget >/dev/null 2>&1 || warn "curl/wget not found; some installs may be skipped."

log "Bootstrapping dotfiles for $USER"

# ---------- clone / update ----------
if [ ! -d "$DOTDIR/.git" ]; then
  log "Cloning $REPO_URL into $DOTDIR"
  git clone "$REPO_URL" "$DOTDIR"
else
  log "Dotfiles repo exists. Pulling latest..."
  git -C "$DOTDIR" pull --ff-only || warn "Could not pull latest (skipping)."
fi

cd "$DOTDIR"

# ---------- optional: Oh-My-Zsh ----------
if [ "$INSTALL_OMZ" -eq 1 ]; then
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh-My-Zsh..."
    export RUNZSH=no CHSH=no KEEP_ZSHRC=yes
    if command -v curl >/dev/null 2>&1; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    elif command -v wget >/dev/null 2>&1; then
      sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
      warn "No curl/wget; skipping Oh-My-Zsh install."
    fi
  else
    ok "Oh-My-Zsh already present"
  fi
fi

# ---------- optional: Powerlevel10k ----------
if [ "$INSTALL_P10K" -eq 1 ] && [ -d "$HOME/.oh-my-zsh" ]; then
  THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [ ! -d "$THEME_DIR" ]; then
    log "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
  else
    ok "Powerlevel10k already present"
  fi
fi

# ---------- backup & link ----------
log "Linking configuration files"
mkdir -p "$BACKUP"
for item in "${LINKS[@]}"; do
  src="$DOTDIR/$item"
  dst="$HOME/$item"

  [[ -e "$src" || -L "$src" ]] || { warn "skip: $item (not in repo)"; continue; }

  if [[ -e "$dst" || -L "$dst" ]]; then
    log "backup: $dst -> $BACKUP/"
    mv -f "$dst" "$BACKUP/" || warn "could not move $dst (check perms)"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  ok "link: $dst -> $src"
done
ok "Symlinks updated"

# ---------- Vim: ensure Gruvbox ----------
log "Ensuring Gruvbox for Vim"
mkdir -p "$HOME/.vim/colors"
GRUV_DST="$HOME/.vim/colors/gruvbox.vim"
if [ ! -f "$GRUV_DST" ]; then
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim -o "$GRUV_DST" || warn "Gruvbox download failed"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$GRUV_DST" https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim || warn "Gruvbox download failed"
  else
    warn "No curl/wget; skipping Gruvbox"
  fi
fi
[ -f "$GRUV_DST" ] && ok "Gruvbox ready" || warn "Gruvbox not installed"

print
ok "Bootstrap complete"
print -P "%F{yellow}Backup:%f $BACKUP"
print -P "%F{yellow}Note:%f 'exec zsh' or open a new shell to load configs."
