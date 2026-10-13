#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dotfiles installer
#
#  Links every config in this repo into your home folder.
#  Existing files are moved to ~/.dotfiles-backup/<date>/ first,
#  so nothing is ever deleted.
#
#  Usage:
#    ./install.sh            link configs only
#    ./install.sh --all      also install Homebrew apps, Oh My Zsh,
#                            Powerlevel10k, plugins and themes
# ─────────────────────────────────────────────────────────────
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
OS="$(uname -s)"

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
info()  { printf '  \033[34m•\033[0m %s\n' "$*"; }
ok()    { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn()  { printf '  \033[33m!\033[0m %s\n' "$*"; }

# link <file in repo> <target path>
link() {
  local src="$DOTFILES/$1" dst="$2"
  [[ -e "$src" ]] || { warn "missing in repo: $1"; return; }
  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    ok "$dst (already linked)"
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP"
    mv "$dst" "$BACKUP/"
    info "backed up old $(basename "$dst") → $BACKUP/"
  fi
  ln -s "$src" "$dst"
  ok "$dst"
}

clone_if_missing() {
  local repo="$1" dir="$2"
  if [[ -d "$dir" ]]; then ok "$(basename "$dir") (already installed)"
  else git clone --depth=1 -q "$repo" "$dir" && ok "$(basename "$dir")"; fi
}

install_extras() {
  bold "📦 Installing apps and shell extras"

  if [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew >/dev/null; then
      info "installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew bundle --file="$DOTFILES/Brewfile"
  else
    warn "not macOS: skipping Brewfile (see linux/README.md)"
  fi

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
  bold "🔗 Linking configs"
  link zsh/.zshrc       "$HOME/.zshrc"
  link zsh/.zprofile    "$HOME/.zprofile"
  link zsh/.p10k.zsh    "$HOME/.p10k.zsh"
  link bash/.bashrc     "$HOME/.bashrc"

  link alacritty/.config/alacritty/alacritty.toml     "$HOME/.config/alacritty/alacritty.toml"
  link btop/.config/btop/btop.conf                    "$HOME/.config/btop/btop.conf"

  if [[ "$OS" == "Darwin" ]]; then
    link linearmouse/.config/linearmouse/linearmouse.json "$HOME/.config/linearmouse/linearmouse.json"
    link vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
  else
    link vscode/settings.json "$HOME/.config/Code/User/settings.json"
  fi
  echo
}

main() {
  echo
  bold "✨ dotfiles: $DOTFILES"
  echo
  if [[ "${1:-}" == "--all" ]]; then install_extras; fi
  link_configs
  bold "🎉 Done! Open a new terminal to see the changes."
  if [[ -d "$BACKUP" ]]; then info "your old files are in $BACKUP"; fi
  echo
}

main "$@"
