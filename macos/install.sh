#!/usr/bin/env bash
# macOS part of the installer. Run it through ../install.sh (or on its own).
#   ./install.sh --all   also installs Homebrew apps, Oh My Zsh, Powerlevel10k, plugins and themes
set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# shellcheck source=../shared/lib.sh
source "$DOTFILES/shared/lib.sh"

install_extras() {
  bold "📦 Installing apps and shell extras"

  if ! command -v brew >/dev/null; then
    info "installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew bundle --file="$DOTFILES/macos/apps/Brewfile"

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  clone_if_missing https://github.com/romkatv/powerlevel10k.git              "$custom/themes/powerlevel10k"
  clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git      "$custom/plugins/zsh-autosuggestions"
  clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git  "$custom/plugins/zsh-syntax-highlighting"
  clone_if_missing https://github.com/catppuccin/alacritty.git               "$HOME/.config/alacritty/themes"
  echo
}

link_configs() {
  bold "🔗 Linking macOS configs"
  link macos/terminal/zsh/.zshrc       "$HOME/.zshrc"
  link macos/terminal/zsh/.zprofile    "$HOME/.zprofile"
  link macos/terminal/zsh/.p10k.zsh    "$HOME/.p10k.zsh"
  link macos/terminal/alacritty/.config/alacritty/alacritty.toml "$HOME/.config/alacritty/alacritty.toml"
  link macos/apps/linearmouse/.config/linearmouse/linearmouse.json "$HOME/.config/linearmouse/linearmouse.json"
  echo
}

if [[ "${1:-}" == "--all" ]]; then install_extras; fi
link_configs
