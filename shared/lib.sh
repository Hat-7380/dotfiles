#!/usr/bin/env bash
# Helpers shared by every installer. Source it, don't run it.
# The caller sets DOTFILES (repo root) before sourcing.

BACKUP="${BACKUP:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
info()  { printf '  \033[34m•\033[0m %s\n' "$*"; }
ok()    { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn()  { printf '  \033[33m!\033[0m %s\n' "$*"; }

# link <file in repo> <target path>
# Existing files are moved to $BACKUP first, so nothing is ever deleted.
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
