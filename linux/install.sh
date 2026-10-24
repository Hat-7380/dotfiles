#!/usr/bin/env bash
# One-shot installer: kitty + Catppuccin Frappe + JetBrainsMono Nerd Font
# + zsh (zinit plugins) + oh-my-posh "zen" prompt + fzf + zoxide.
# Existing files are backed up to <file>.bak-<timestamp>. Safe to re-run.
set -euo pipefail

DOTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
say() { printf '\033[1;35m==>\033[0m %s\n' "$*"; }

# ── 1. Packages ──────────────────────────────────────
say "Installing packages (kitty zsh git fzf zoxide curl unzip)"
if   command -v dnf    >/dev/null; then sudo dnf install -y kitty zsh git fzf zoxide curl unzip fontconfig eza fd-find btop git-delta tealdeer neovim bat ripgrep tmux
elif command -v apt    >/dev/null; then sudo apt update && sudo apt install -y kitty zsh git fzf zoxide curl unzip fontconfig fd-find btop git-delta neovim bat ripgrep tmux
elif command -v pacman >/dev/null; then sudo pacman -S --needed --noconfirm kitty zsh git fzf zoxide curl unzip fontconfig eza fd btop git-delta tealdeer neovim bat ripgrep tmux lazygit
elif command -v brew   >/dev/null; then brew install --cask kitty; brew install zsh git fzf zoxide curl eza fd btop git-delta tealdeer neovim bat ripgrep tmux lazygit
else echo "Unsupported package manager: install kitty zsh git fzf zoxide manually, then re-run."; exit 1; fi

# ── 2. oh-my-posh ────────────────────────────────────
if ! command -v oh-my-posh >/dev/null; then
  say "Installing oh-my-posh to ~/.local/bin"
  mkdir -p "$HOME/.local/bin"
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi

# ── 2b. lazygit (not in Fedora/Debian repos) ────────
if ! command -v lazygit >/dev/null; then
  say "Installing lazygit to ~/.local/bin"
  tmp="$(mktemp -d)"
  url="$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -o 'https://[^"]*linux_x86_64.tar.gz' | head -1)"
  if [ -n "$url" ]; then
    curl -fsSL -o "$tmp/lg.tgz" "$url" && tar -xzf "$tmp/lg.tgz" -C "$tmp" lazygit \
      && install -m755 "$tmp/lazygit" "$HOME/.local/bin/lazygit"
  fi
  rm -rf "$tmp"
fi

# ── 3. JetBrainsMono Nerd Font ───────────────────────
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  say "Installing JetBrainsMono Nerd Font"
  FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
  mkdir -p "$FONT_DIR"
  tmp="$(mktemp -d)"
  curl -fL -o "$tmp/jb.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -oq "$tmp/jb.zip" -d "$FONT_DIR"
  rm -rf "$tmp"
  fc-cache -f
fi

# ── 4. Symlink configs ───────────────────────────────
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ] && return 0
    mv "$dst" "$dst.bak-$STAMP"; say "Backed up $dst"
  fi
  ln -s "$src" "$dst"; say "Linked $dst"
}
link "$DOTS/terminals/kitty/.config/kitty/kitty.conf"          "$HOME/.config/kitty/kitty.conf"
link "$DOTS/terminals/kitty/.config/kitty/current-theme.conf"  "$HOME/.config/kitty/current-theme.conf"
link "$DOTS/shell/ohmyposh/.config/ohmyposh/zen.toml"         "$HOME/.config/ohmyposh/zen.toml"
link "$DOTS/shell/zsh/.zshrc"                "$HOME/.zshrc"

# ── 5. Default shell ─────────────────────────────────
if [ "${SHELL##*/}" != "zsh" ]; then
  say "Setting zsh as default shell (may ask for your password)"
  chsh -s "$(command -v zsh)" || echo "Couldn't chsh; run: chsh -s \$(command -v zsh)"
fi

say "Done! Open a new kitty window. First launch downloads zsh plugins (takes a few seconds)."
