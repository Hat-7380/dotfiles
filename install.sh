#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
#  dotfiles installer
#
#  Links the shared configs, then runs the installer for your system
#  (macos/install.sh or linux/install.sh).
#  Existing files are moved to ~/.dotfiles-backup/<date>/ first,
#  so nothing is ever deleted.
#
#  Usage:
#    ./install.sh            link configs only
#    ./install.sh --all      also install apps and shell extras
# ─────────────────────────────────────────────────────────────
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES
# shellcheck source=shared/lib.sh
source "$DOTFILES/shared/lib.sh"
export BACKUP

link_shared() {
  bold "🔗 Linking shared configs"
  link shared/bash/.bashrc                  "$HOME/.bashrc"
  link shared/btop/.config/btop/btop.conf   "$HOME/.config/btop/btop.conf"

  for theme in "$DOTFILES"/shared/claude-themes/*.json; do
    link "shared/claude-themes/$(basename "$theme")" "$HOME/.claude/themes/$(basename "$theme")"
  done

  if [[ "$(uname -s)" == "Darwin" ]]; then
    link shared/vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"
  else
    link shared/vscode/settings.json "$HOME/.config/Code/User/settings.json"
  fi
  echo
}

main() {
  echo
  bold "✨ dotfiles: $DOTFILES"
  echo
  link_shared

  case "$(uname -s)" in
    Darwin) "$DOTFILES/macos/install.sh" "$@" ;;
    Linux)  "$DOTFILES/linux/install.sh"  "$@" ;;
    *)      warn "unknown system $(uname -s): only shared configs were linked" ;;
  esac

  bold "🎉 Done! Open a new terminal to see the changes."
  if [[ -d "$BACKUP" ]]; then info "your old files are in $BACKUP"; fi
  echo
}

main "$@"
