#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# setup.sh — portable Vim bootstrap (works on old Vim 7.4; no +packages needed)
# Installs:
#   - gruvbox colorscheme into ~/.vim/colors/
#   - rainbow plugin into ~/.vim/plugin/ (and ~/.vim/autoload/ if present)
#
# Requirements: git, vim
# ============================================================================

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1" >&2; exit 1; }; }

need git
need vim

REPO_CACHE="${HOME}/.vim/.deps"
GRUVBOX_DIR="${REPO_CACHE}/gruvbox"
RAINBOW_DIR="${REPO_CACHE}/rainbow"

mkdir -p "${REPO_CACHE}"
mkdir -p "${HOME}/.vim/colors" "${HOME}/.vim/plugin" "${HOME}/.vim/autoload" "${HOME}/.vim/doc"

echo "[*] Fetching/updating plugin sources into ${REPO_CACHE} ..."

# --- gruvbox ---
if [[ -d "${GRUVBOX_DIR}/.git" ]]; then
  git -C "${GRUVBOX_DIR}" pull --ff-only
else
  git clone https://github.com/morhetz/gruvbox.git "${GRUVBOX_DIR}"
fi

# --- rainbow ---
if [[ -d "${RAINBOW_DIR}/.git" ]]; then
  git -C "${RAINBOW_DIR}" pull --ff-only
else
  git clone https://github.com/luochen1990/rainbow.git "${RAINBOW_DIR}"
fi

echo "[*] Installing gruvbox colorscheme (classic location) ..."
# This is what :colorscheme searches by default on older Vim
cp -f "${GRUVBOX_DIR}/colors/gruvbox.vim" "${HOME}/.vim/colors/gruvbox.vim"

echo "[*] Installing rainbow plugin (classic location) ..."
# Vim loads ~/.vim/plugin/*.vim automatically
if compgen -G "${RAINBOW_DIR}/plugin/*.vim" > /dev/null; then
  cp -f "${RAINBOW_DIR}/plugin/"*.vim "${HOME}/.vim/plugin/"
else
  # Some repos have plugin/ as a directory with nested files; copy recursively safely
  cp -rf "${RAINBOW_DIR}/plugin/." "${HOME}/.vim/plugin/"
fi

# Some plugins also use autoload/ for functions
if [[ -d "${RAINBOW_DIR}/autoload" ]]; then
  cp -rf "${RAINBOW_DIR}/autoload/." "${HOME}/.vim/autoload/" || true
fi

# Optional: install help docs if present and generate helptags
if [[ -d "${RAINBOW_DIR}/doc" ]]; then
  cp -rf "${RAINBOW_DIR}/doc/." "${HOME}/.vim/doc/" || true
fi
if [[ -d "${GRUVBOX_DIR}/doc" ]]; then
  cp -rf "${GRUVBOX_DIR}/doc/." "${HOME}/.vim/doc/" || true
fi

echo "[*] Generating helptags (optional, but nice) ..."
vim -Es +'silent! helptags ~/.vim/doc' +qall || true

cat <<'EOF'

[*] Done.

Test in Vim:
  :colorscheme gruvbox
  (type nested parentheses to see rainbow if enabled in your .vimrc)

If rainbow doesn't show:
  ensure your .vimrc has:
    let g:rainbow_active = 1
EOF
