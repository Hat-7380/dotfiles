# 🐧 Linux

My Fedora setup: **kitty** + Catppuccin Frappé + JetBrainsMono Nerd Font, **zsh** with zinit plugins, and the **oh-my-posh** `zen` prompt.

| Tool | Config |
|------|--------|
| kitty (90% opacity, beam cursor with trail, round powerline tabs) | [`kitty/`](kitty/.config/kitty/) |
| zsh + [zinit](https://github.com/zdharma-continuum/zinit): syntax highlighting, completions, autosuggestions, fzf-tab | [`zsh/.zshrc`](zsh/.zshrc) |
| [oh-my-posh](https://ohmyposh.dev) `zen` prompt | [`ohmyposh/`](ohmyposh/.config/ohmyposh/zen.toml) |
| `fzf` + `zoxide` | loaded in `.zshrc` |
| CLI tools: `eza`, `bat`, `fd`, `ripgrep`, `btop`, `lazygit`, `git-delta`, `tealdeer`, `neovim`, `tmux` | installed by `install.sh`; aliases (`ls`, `ll`, `la`, `lt`, `lg`, `top`, `cat`) in `.zshrc` |

## Install

```bash
git clone https://github.com/Hat-7380/dotfiles.git ~/dotfiles
cd ~/dotfiles/linux
./install.sh
```

Works on Fedora (dnf), Debian/Ubuntu (apt), Arch (pacman) and macOS (brew). It installs the packages, oh-my-posh and the Nerd Font, then symlinks the configs. Anything it replaces is backed up as `<file>.bak-<timestamp>`, so it is safe to re-run. Open a new kitty window afterwards; the first launch downloads the zsh plugins.

> This uses `linux/zsh/.zshrc`, not the macOS Powerlevel10k one in `zsh/`. Don't run the top-level `install.sh` on top of it.

## Dev tools (optional)

```bash
./dev-setup.sh
```

Installs Python (pip, pipx, [uv](https://docs.astral.sh/uv/)), Go, Rust (rustup), gcc/make/cmake and VS Code, with my VS Code settings and extensions. The prompt shows the Python, Node, Go and Rust version when you're inside a matching project.

## GNOME rice (optional)

```bash
./gnome/apply.sh
```

Catppuccin Frappé across the desktop: dark mode, adw-gtk3, Papirus icons, purple accent, recolored GTK3/GTK4 apps, Blur my Shell and a matching fastfetch. Your old settings are backed up first.

## Shortcuts

| Keys | Action |
|---|---|
| `Ctrl+C` / `Ctrl+V` | Copy (or interrupt) / paste |
| `Ctrl+Shift` `+` / `-` / `Backspace` | Font bigger / smaller / reset |
| `Ctrl+Shift+O` / `Ctrl+Shift+P` | Opacity up / down |
| `Ctrl+P` / `Ctrl+N` | Search shell history back / forward |
