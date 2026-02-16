#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[*] Installing shell configuration..."

ln -sf "$REPO_DIR/bashrc" "$HOME/.bashrc"
ln -sf "$REPO_DIR/bash_profile" "$HOME/.bash_profile"

echo "[*] Done."
echo "Run: source ~/.bashrc"
