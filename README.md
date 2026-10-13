<div align="center">

# ⚙️ dotfiles

**My terminal, editor, and desktop setup: everything I need to feel at home on a new machine.**

<img src="https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white" />
<img src="https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black" />
<img src="https://img.shields.io/badge/zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white" />
<img src="https://img.shields.io/badge/Alacritty-F46D01?style=for-the-badge&logo=alacritty&logoColor=white" />
<img src="https://img.shields.io/badge/Catppuccin-D97757?style=for-the-badge" />

</div>

---

## 🧰 What's inside

| | Tool | Config | Notes |
|---|------|--------|-------|
| 🐚 | **zsh** + [Oh My Zsh](https://ohmyz.sh) | [`zsh/.zshrc`](zsh/.zshrc) | autosuggestions, syntax highlighting, `z`, `sudo`, web-search |
| 💲 | **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** | [`zsh/.p10k.zsh`](zsh/.p10k.zsh) | the prompt; run `p10k configure` to restyle |
| 🖥️ | **[Alacritty](https://alacritty.org)** | [`alacritty.toml`](alacritty/.config/alacritty/alacritty.toml) | Catppuccin Frappé, blur, 95% opacity, JetBrains Mono Nerd Font |
| 📊 | **[btop](https://github.com/aristocratos/btop)** | [`btop.conf`](btop/.config/btop/btop.conf) | system monitor |
| 🖱️ | **[LinearMouse](https://linearmouse.app)** | [`linearmouse.json`](linearmouse/.config/linearmouse/linearmouse.json) | mouse & trackpad tweaks (macOS) |
| 🤖 | **[Claude Code](https://code.claude.com)** | [`claude/themes/`](claude/themes/) | 7 custom themes: Catppuccin Frappé & Mocha, Tokyo Night, Kanagawa, Gruvbox, Rosé Pine, Dracula. Pick one with `/theme` |
| 📝 | **VS Code** | [`vscode/settings.json`](vscode/settings.json) | One Dark Pro Night Flat, Material Icons, Fira Code, no minimap |
| 🍺 | **Homebrew** | [`Brewfile`](Brewfile) | every CLI tool, app, font, and VS Code extension I use |
| 🖼️ | **Wallpapers** | [`wallpapers/`](wallpapers/) | with credits |
| ⌨️ | **Shortcuts** | [`SHORTCUTS.md`](SHORTCUTS.md) | all my keys and aliases on one page |
| 🐧 | **Linux** | [`linux/`](linux/) | *coming soon* |

## 🛠️ CLI tools I use

| Tool | Replaces | What for |
|------|----------|----------|
| [`lsd`](https://github.com/lsd-rs/lsd) / [`eza`](https://github.com/eza-community/eza) | `ls` | file lists with colors and icons |
| [`bat`](https://github.com/sharkdp/bat) | `cat` | syntax-highlighted file viewer |
| [`fd`](https://github.com/sharkdp/fd) | `find` | fast, simple file search |
| [`fzf`](https://github.com/junegunn/fzf) | — | fuzzy finder for history, files, folders |
| [`lazygit`](https://github.com/jesseduffield/lazygit) | — | git in a terminal UI |
| [`git-delta`](https://github.com/dandavison/delta) | `diff` | beautiful git diffs |
| [`btop`](https://github.com/aristocratos/btop) | `top` | system monitor |
| [`fastfetch`](https://github.com/fastfetch-cli/fastfetch) | `neofetch` | system info with a logo |
| [`gh`](https://cli.github.com) | — | GitHub from the terminal |

## 🚀 Install

> ⚠️ Read the scripts before running them on your machine. These are **my** settings, so take what you like.

```bash
git clone https://github.com/Hat-7380/dotfiles.git ~/dotfiles
cd ~/dotfiles

./install.sh          # link the configs only
./install.sh --all    # also install Homebrew apps, Oh My Zsh, Powerlevel10k, plugins and themes
```

**How it works:** `install.sh` creates *symlinks* from your home folder to the files in this repo. Edit `~/.zshrc` and you're really editing `~/dotfiles/zsh/.zshrc`, so changes are ready to commit.

**Nothing gets deleted.** Any existing config is moved to `~/.dotfiles-backup/<date>/` before linking.

## 📁 Structure

```
dotfiles/
├── install.sh                 ← one-command setup
├── Brewfile                   ← apps & tools (brew bundle)
├── SHORTCUTS.md               ← keys and aliases cheat sheet
├── zsh/                       ← .zshrc  .zprofile  .p10k.zsh
├── bash/                      ← .bashrc
├── alacritty/.config/...      ← terminal
├── btop/.config/...           ← system monitor
├── linearmouse/.config/...    ← mouse (macOS)
├── claude/themes/             ← Claude Code themes
├── vscode/                    ← editor settings
├── wallpapers/                ← backgrounds + credits
└── linux/                     ← Linux-specific setup (soon)
```

## 🔒 Secrets

No passwords, tokens, or keys live in this repo. Machine-specific or private settings go in `~/.zshrc.local`, which `.zshrc` loads automatically and git ignores.

## ✏️ Updating

```bash
cd ~/dotfiles
brew bundle dump --force   # refresh Brewfile after installing new apps
git add -A && git commit -m "update configs" && git push
```

---

<div align="center">
<sub>Made by <a href="https://github.com/Hat-7380">@Hat-7380</a> · feel free to borrow anything</sub>
</div>
