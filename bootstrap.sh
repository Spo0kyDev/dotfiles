#!/usr/bin/env bash
set -e

echo "🚀 Bootstrapping dotfiles for $USER..."

# Ensure repo exists
if [ ! -d "$HOME/dotfiles/.git" ]; then
  echo "Cloning dotfiles..."
  git clone git@github.com:Spo0kyDev/dotfiles.git "$HOME/dotfiles"
fi

cd "$HOME/dotfiles" || exit 1

# Symlink configs
ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
[ -f "$HOME/dotfiles/.vimrc" ] && ln -sf "$HOME/dotfiles/.vimrc" "$HOME/.vimrc"
[ -f "$HOME/dotfiles/.dircolors" ] && ln -sf "$HOME/dotfiles/.dircolors" "$HOME/.dircolors"

# Reload Zsh if present
if command -v zsh >/dev/null 2>&1; then
  echo "Reloading zsh..."
  source "$HOME/.zshrc"
fi

# -------------------------------------------------------------------
# Vim setup: ensure Gruvbox is installed
# -------------------------------------------------------------------
echo "🔧 Setting up Vim Gruvbox theme..."
mkdir -p "$HOME/.vim/colors"
if [ ! -f "$HOME/.vim/colors/gruvbox.vim" ]; then
  curl -fsSL https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim \
    -o "$HOME/.vim/colors/gruvbox.vim"
  echo "✅ Gruvbox installed for Vim."
else
  echo "⚡ Gruvbox already installed for Vim."
fi


echo "✅ Dotfiles bootstrapped!"

