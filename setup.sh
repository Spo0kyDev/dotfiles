#!/usr/bin/env bash
set -euo pipefail

# Install gruvbox + rainbow using Vim's built-in "packages" system.
# No plugin manager required.

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1" >&2; exit 1; }; }

need git
need vim

PKG="$HOME/.vim/pack/plugins/start"
mkdir -p "$PKG"

# Install or update gruvbox
if [[ -d "$PKG/gruvbox/.git" ]]; then
  git -C "$PKG/gruvbox" pull --ff-only
else
  git clone https://github.com/morhetz/gruvbox.git "$PKG/gruvbox"
fi

# Install or update rainbow
if [[ -d "$PKG/rainbow/.git" ]]; then
  git -C "$PKG/rainbow" pull --ff-only
else
  git clone https://github.com/luochen1990/rainbow.git "$PKG/rainbow"
fi

cat <<'EOF'

Installed:
  - gruvbox
  - rainbow

Now ensure your ~/.vimrc has:
  set background=dark
  try | colorscheme gruvbox | catch | endtry
  let g:rainbow_active = 1

Test inside Vim:
  :colorscheme gruvbox
EOF
