#!/usr/bin/env bash
# Optional dev tools: Python (pip, pipx, uv), Go, Rust (rustup), build tools, VS Code.
# Run after install.sh. Fedora/dnf only for the system packages.
set -euo pipefail
say() { printf '\033[1;35m==>\033[0m %s\n' "$*"; }

say "System packages (python, pipx, go, gcc, make, cmake)"
sudo dnf install -y python3-pip pipx golang gcc gcc-c++ make cmake

if ! command -v code >/dev/null; then
  say "VS Code (Microsoft repo)"
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  printf '[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\n' | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
  sudo dnf install -y code
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
say "VS Code settings + extensions"
mkdir -p "$HOME/.config/Code/User"
ln -sfn "$REPO_ROOT/shared/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
grep -i '^vscode' "$REPO_ROOT/macos/apps/Brewfile" | sed 's/.*"\(.*\)".*/\1/' | while read -r ext; do
  code --install-extension "$ext" --force || echo "Skipped $ext"
done

if ! command -v rustc >/dev/null && [ ! -x "$HOME/.cargo/bin/rustc" ]; then
  say "Rust (rustup)"
  curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

if ! command -v uv >/dev/null; then
  say "uv (fast Python package/version manager)"
  curl -fsSL https://astral.sh/uv/install.sh | UV_NO_MODIFY_PATH=1 sh
fi

pipx ensurepath >/dev/null || true
say "Done. Open a new terminal. ~/.cargo/bin and ~/.local/bin are already on PATH via .zshrc."
