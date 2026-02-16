#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# setup.sh — Vim bootstrap for old Vim (7.4) + reset-prone servers
#
# Installs:
#   - Gruvbox colorscheme -> ~/.vim/colors/gruvbox.vim
#   - Rainbow plugin      -> ~/.vim/plugin/ (and ~/.vim/autoload/ if present)
#
# Requires: git, vim
# ============================================================================

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1" >&2; exit 1; }; }

need git
need vim

CACHE="$HOME/.vim/.deps"
GRUVBOX="$CACHE/gruvbox"
RAINBOW="$CACHE/rainbow"

mkdir -p "$CACHE"
mkdir -p "$HOME/.vim/colors" "$HOME/.vim/plugin" "$HOME/.vim/autoload" "$HOME/.vim/doc"

echo "[*] Updating sources in $CACHE ..."

# Fetch or update gruvbox
if [[ -d "$GRUVBOX/.git" ]]; then
  git -C "$GRUVBOX" pull --ff-only
else
  git clone https://github.com/morhetz/gruvbox.git "$GRUVBOX"
fi

# Fetch or update rainbow
if [[ -d "$RAINBOW/.git" ]]; then
  git -C "$RAINBOW" pull --ff-only
else
  git clone https://github.com/luochen1990/rainbow.git "$RAINBOW"
fi

echo "[*] Installing gruvbox -> ~/.vim/colors/gruvbox.vim"
cp -f "$GRUVBOX/colors/gruvbox.vim" "$HOME/.vim/colors/gruvbox.vim"

echo "[*] Installing rainbow -> ~/.vim/plugin/"
# plugin/
if [[ -d "$RAINBOW/plugin" ]]; then
  cp -rf "$RAINBOW/plugin/." "$HOME/.vim/plugin/"
fi
# autoload/ (some plugins use this)
if [[ -d "$RAINBOW/autoload" ]]; then
  cp -rf "$RAINBOW/autoload/." "$HOME/.vim/autoload/" || true
fi

# Optional docs + helptags
if [[ -d "$GRUVBOX/doc" ]]; then
  cp -rf "$GRUVBOX/doc/." "$HOME/.vim/doc/" || true
fi
if [[ -d "$RAINBOW/doc" ]]; then
  cp -rf "$RAINBOW/doc/." "$HOME/.vim/doc/" || true
fi

echo "[*] Generating helptags (optional)"
vim -Es +'silent! helptags ~/.vim/doc' +qall || true

cat <<'EOF'

[*] Done.

Open Vim and test:
  :colorscheme gruvbox
  (rainbow works if your .vimrc has: let g:rainbow_active = 1)

EOF
