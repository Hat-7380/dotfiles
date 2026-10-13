#!/usr/bin/env bash
# Catppuccin Frappé GNOME rice: dark mode, adw-gtk3, Papirus icons, purple accent,
# recolored GTK3/GTK4 apps, Blur my Shell, fastfetch config.
# Backs up your current GNOME settings first (restore: dconf load / < <backup>).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
say() { printf '\033[1;35m==>\033[0m %s\n' "$*"; }

mkdir -p "$HOME/Documents/rice-backup"
dconf dump / > "$HOME/Documents/rice-backup/dconf-before-rice-$(date +%F-%H%M%S).conf"
say "Backed up current settings to ~/Documents/rice-backup"

say "Needs: adw-gtk3 theme, Papirus icons (sudo dnf install adw-gtk3-theme papirus-icon-theme)"
for d in gtk-3.0 gtk-4.0; do
  mkdir -p "$HOME/.config/$d"
  [ -e "$HOME/.config/$d/gtk.css" ] && [ ! -L "$HOME/.config/$d/gtk.css" ] && mv "$HOME/.config/$d/gtk.css" "$HOME/.config/$d/gtk.css.bak"
  ln -sfn "$DIR/gtk.css" "$HOME/.config/$d/gtk.css"
done

g=org.gnome.desktop.interface
gsettings set $g color-scheme 'prefer-dark'
gsettings set $g gtk-theme 'adw-gtk3-dark'
gsettings set $g icon-theme 'Papirus-Dark'
gsettings set $g accent-color 'purple'
gsettings set $g monospace-font-name 'JetBrainsMono Nerd Font Mono 11'
gsettings set $g enable-hot-corners false

# Nautilus (file manager)
n=org.gnome.nautilus
gsettings set $n.preferences default-folder-viewer 'list-view'
gsettings set $n.preferences date-time-format 'detailed'
gsettings set $n.preferences show-image-thumbnails 'always'
gsettings set $n.preferences show-directory-item-counts 'always'
gsettings set $n.preferences show-create-link true
gsettings set $n.list-view use-tree-view true
gsettings set $n.list-view default-visible-columns "['name', 'size', 'type', 'date_modified']"
gsettings set $n.icon-view default-zoom-level 'medium'
gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
# "Open in Terminal" uses kitty
gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
nautilus -q 2>/dev/null || true

mkdir -p "$HOME/.config/fastfetch"
ln -sfn "$DIR/../fastfetch/.config/fastfetch/config.jsonc" "$HOME/.config/fastfetch/config.jsonc"
ln -sfn "$DIR/../fastfetch/.config/fastfetch/clawd.png" "$HOME/.config/fastfetch/claude.png"

gnome-extensions enable blur-my-shell@aunetx 2>/dev/null || say "Install the 'Blur my Shell' extension, then re-run"
# Purple Papirus folders (optional): get https://github.com/PapirusDevelopmentTeam/papirus-folders and run:
#   papirus-folders -t Papirus-Dark -C violet
say "Done. Log out and back in for everything to apply."
