#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SRC_BASHRC="$REPO_DIR/.bashrc"
SRC_PROFILE="$REPO_DIR/.bash_profile"

echo "[*] Installing shell configuration from: $REPO_DIR"

# Ensure source files exist
if [[ ! -f "$SRC_BASHRC" ]]; then
    echo "[!] Missing $SRC_BASHRC"
    exit 1
fi

if [[ ! -f "$SRC_PROFILE" ]]; then
    echo "[!] Missing $SRC_PROFILE"
    exit 1
fi

# Remove broken symlinks if present
if [[ -L "$HOME/.bashrc" && ! -e "$HOME/.bashrc" ]]; then
    rm "$HOME/.bashrc"
fi

if [[ -L "$HOME/.bash_profile" && ! -e "$HOME/.bash_profile" ]]; then
    rm "$HOME/.bash_profile"
fi

# Create symlinks
ln -sf "$SRC_BASHRC" "$HOME/.bashrc"
ln -sf "$SRC_PROFILE" "$HOME/.bash_profile"

echo "[*] Shell configuration linked successfully."
echo "Log out and back in, or run: source ~/.bashrc"
