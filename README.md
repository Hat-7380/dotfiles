<div align="center">

# ⚙️ dotfiles

**Customizing my workflow until it feels perfect.**

**Linux** &nbsp;·&nbsp; [Fedora](https://fedoraproject.org) · [GNOME](https://www.gnome.org) · [kitty](https://sw.kovidgoyal.net/kitty/) · [zsh](https://www.zsh.org) · [oh-my-posh](https://ohmyposh.dev) · [fastfetch](https://github.com/fastfetch-cli/fastfetch)<br>
**macOS** &nbsp;·&nbsp; [Alacritty](https://alacritty.org) · [Oh My Zsh](https://ohmyz.sh) · [Powerlevel10k](https://github.com/romkatv/powerlevel10k) · [Homebrew](https://brew.sh)<br>
**Theme** &nbsp;·&nbsp; [Catppuccin](https://catppuccin.com)

</div>

---

## 👋 About

This repo is my customization and the workflow I'm slowly perfecting: the terminal, the shell, the prompt, the desktop and the small tools around them. It is never finished. I keep changing things, and whatever I like ends up here.

It is made to be borrowed. Every setup is a few plain config files plus an installer, so you can copy one piece or the whole thing. It is quick to try, and nothing is deleted when you do.

## 🚀 Quick start

```bash
git clone https://github.com/Hat-7380/dotfiles.git ~/dotfiles
cd ~/dotfiles

./install.sh          # link the configs only
./install.sh --all    # also install apps and shell extras
```

`install.sh` detects your system and runs the right installer (`macos/` or `linux/`).

- **Symlinks:** your home folder links to the files in this repo. Edit `~/.zshrc` and you are editing the repo, so changes are ready to commit.
- **Nothing gets deleted:** any existing config is moved to `~/.dotfiles-backup/<date>/` before linking.
- **Read before you run:** these are *my* settings. Look at the scripts first and take what you like.

---

## 🐧 Linux

My daily setup, on **Fedora** with GNOME. The installer also works on Debian/Ubuntu, Arch and Homebrew.

<p align="center"><img src="docs/images/linux-desktop.svg" alt="Linux desktop" width="820"></p>

| | What | Config | Details |
|---|------|--------|---------|
| 🐱 | **[kitty](https://sw.kovidgoyal.net/kitty/)** | [`kitty.conf`](linux/kitty/.config/kitty/kitty.conf) | Catppuccin Frappé, 90% opacity, beam cursor with a trail, round powerline tabs, no window decorations, JetBrainsMono Nerd Font 14 |
| 🐚 | **zsh** + [zinit](https://github.com/zdharma-continuum/zinit) | [`.zshrc`](linux/zsh/.zshrc) | syntax highlighting, autosuggestions, completions, `fzf-tab`, plus git, sudo, kubectl and aws snippets |
| 💲 | **[oh-my-posh](https://ohmyposh.dev)** | [`zen.toml`](linux/ohmyposh/.config/ohmyposh/zen.toml) | the minimal `zen` prompt: path and git status, plus user@host over SSH |
| 🖥️ | **[fastfetch](https://github.com/fastfetch-cli/fastfetch)** | [`config.jsonc`](linux/fastfetch/.config/fastfetch/config.jsonc) | runs when kitty opens; Claude Code mascot logo and your token usage |
| 🎨 | **GNOME rice** | [`gnome/`](linux/gnome/) | Catppuccin Frappé for the whole desktop (see below) |
| 🧰 | **CLI tools** | [`install.sh`](linux/install.sh) | `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `zoxide`, `btop`, `lazygit`, `git-delta`, `tealdeer`, `neovim`, `tmux` |
| 💻 | **Dev tools** (optional) | [`dev-setup.sh`](linux/dev-setup.sh) | Python (pip, pipx, uv), Go, Rust, gcc/make/cmake, VS Code with settings and extensions |

<p align="center"><img src="docs/images/linux-terminal.svg" alt="Linux terminal" width="820"></p>

### Terminal and shell

- **kitty** opens at 100×25, has 10,000 lines of scrollback and copies whatever you select to the clipboard.
- **Opacity and font on the fly:** <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>O</kbd> / <kbd>P</kbd> change opacity, <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>=</kbd> / <kbd>-</kbd> change font size, <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Backspace</kbd> resets it.
- **History:** 5,000 entries shared between sessions, no duplicates. <kbd>Ctrl</kbd>+<kbd>P</kbd> / <kbd>N</kbd> search it by what you already typed.
- **Aliases:** `ls ll la lt` use `eza` with icons and git status, `cat` is `bat`, `lg` is lazygit, `top` is btop, `vim` is neovim, `c` clears the screen.
- **`cd` is `zoxide`:** it learns your folders, so `cd proj` jumps straight there.

### fastfetch with Claude Code usage

Opens with every new kitty window. The small `claude-usage` script reads your local Claude Code history and prints `today · week · all` token counts right in the fetch.

<p align="center"><img src="docs/images/linux-fastfetch.svg" alt="fastfetch" width="820"></p>

### GNOME desktop

`linux/gnome/apply.sh` turns a fresh GNOME into this look. It backs up your current settings first to `~/Documents/rice-backup/`.

- Dark mode, **adw-gtk3-dark** theme, **Papirus-Dark** icons and a purple accent
- GTK3 and GTK4 apps recolored to Catppuccin Frappé ([`gtk.css`](linux/gnome/gtk.css))
- [Blur my Shell](https://extensions.gnome.org/extensions/3193/blur-my-shell/) extension, hot corners off
- Nautilus: list view, detailed dates, thumbnails always on, item counts, folders first
- "Open in Terminal" opens kitty

You need `adw-gtk3-theme` and `papirus-icon-theme` first: `sudo dnf install adw-gtk3-theme papirus-icon-theme`.

### Install

```bash
cd ~/dotfiles
./install.sh            # or: cd linux && ./install.sh
./linux/gnome/apply.sh  # the desktop look (optional, log out and back in after)
./linux/dev-setup.sh    # dev tools (optional, Fedora)
```

The installer uses `sudo` for packages, installs oh-my-posh and the JetBrainsMono Nerd Font, links the configs and sets zsh as your shell. More in [`linux/README.md`](linux/README.md).

---

## 🍎 macOS

Terminal-first: **Alacritty**, **zsh** with Oh My Zsh and Powerlevel10k, and Homebrew for everything else.

<p align="center"><img src="docs/images/macos-terminal.svg" alt="macOS terminal" width="820"></p>

| | What | Config | Details |
|---|------|--------|---------|
| 🖥️ | **[Alacritty](https://alacritty.org)** | [`alacritty.toml`](macos/alacritty/.config/alacritty/alacritty.toml) | Catppuccin Frappé, blur, 95% opacity, 30px padding, JetBrainsMono Nerd Font 16, block cursor that goes hollow when unfocused |
| 🐚 | **zsh** + [Oh My Zsh](https://ohmyz.sh) | [`.zshrc`](macos/zsh/.zshrc) | plugins: git, autosuggestions, syntax highlighting, `z`, `sudo`, web-search |
| 💲 | **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** | [`.p10k.zsh`](macos/zsh/.p10k.zsh) | the prompt; run `p10k configure` to restyle it |
| 🖱️ | **[LinearMouse](https://linearmouse.app)** | [`linearmouse.json`](macos/linearmouse/.config/linearmouse/linearmouse.json) | mouse and trackpad tweaks |
| 🍺 | **Homebrew** | [`Brewfile`](macos/Brewfile) | every CLI tool, app, font and VS Code extension I use |

### Terminal and shell

- **Alacritty:** <kbd>Shift</kbd>+<kbd>Enter</kbd> adds a new line without running the command, <kbd>Option</kbd> works as <kbd>Alt</kbd>, selected text is copied automatically.
- **Aliases:** `ls l la lla lt` use `lsd` with icons.
- **fzf** is loaded for fuzzy history, file and folder search.
- **Local settings:** machine-specific things go in `~/.zshrc.local`, which is loaded if it exists and never committed.
- **`claude` helper:** typing `claude` from your home folder starts Claude Code in `~/projects/work` instead.

### Install

```bash
cd ~/dotfiles
./install.sh --all    # Homebrew apps, Oh My Zsh, Powerlevel10k, plugins and the Alacritty theme
```

---

## 🧩 Shared

Used on both systems.

| | What | Config | Details |
|---|------|--------|---------|
| 📊 | **[btop](https://github.com/aristocratos/btop)** | [`btop.conf`](shared/btop/.config/btop/btop.conf) | system monitor, `top` replacement |
| 📝 | **VS Code** | [`settings.json`](shared/vscode/settings.json) | One Dark Pro Night Flat, Material icons, JetBrainsMono Nerd Font (Fira Code as fallback), no minimap, compact auto-hiding activity bar |
| 🤖 | **[Claude Code](https://code.claude.com) themes** | [`claude-themes/`](shared/claude-themes/) | 7 themes: Catppuccin Frappé and Mocha, Tokyo Night, Kanagawa, Gruvbox, Rosé Pine, Dracula. Pick one with `/theme` |
| 🐚 | **bash** | [`.bashrc`](shared/bash/.bashrc) | a tiny fallback that loads fzf |

## 🖼️ Wallpapers

Wallpapers and their credits live in [`wallpapers/`](wallpapers/).

## ⌨️ Shortcuts

All my keys and aliases on one page: [`docs/SHORTCUTS.md`](docs/SHORTCUTS.md).

---

## 📁 Structure

```
dotfiles/
├── install.sh      picks the macOS or Linux installer for you
├── macos/          Brewfile, zsh + Powerlevel10k, Alacritty, LinearMouse
├── linux/          kitty, zsh, oh-my-posh, fastfetch, GNOME
├── shared/         btop, VS Code, Claude Code themes, bash
├── wallpapers/     backgrounds and credits
└── docs/           shortcuts and screenshots
```

## 🔒 Secrets

No passwords, tokens or keys live in this repo. Private or machine-specific settings go in `~/.zshrc.local`, which git ignores.

## ✏️ Updating

```bash
cd ~/dotfiles
brew bundle dump --force --file=macos/Brewfile   # macOS: refresh the Brewfile
git add -A && git commit -m "update configs" && git push
```

---

<div align="center">
<sub>Made by <a href="https://github.com/Hat-7380">@Hat-7380</a> · feel free to borrow anything</sub>
</div>
