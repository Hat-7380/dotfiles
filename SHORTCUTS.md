# ⌨️ Shortcuts

Everything I use day to day, in one place.

## Terminal (zsh)

| Keys | What it does | Comes from |
|------|--------------|------------|
| <kbd>→</kbd> | Accept the grey suggestion | zsh-autosuggestions |
| <kbd>Esc</kbd> <kbd>Esc</kbd> | Add `sudo` to the start of the command | oh-my-zsh `sudo` |
| <kbd>Ctrl</kbd> + <kbd>R</kbd> | Fuzzy-search command history | fzf |
| <kbd>Ctrl</kbd> + <kbd>T</kbd> | Fuzzy-find a file and paste its path | fzf |
| <kbd>Alt</kbd> + <kbd>C</kbd> | Fuzzy-find a folder and `cd` into it | fzf |
| <kbd>Ctrl</kbd> + <kbd>A</kbd> / <kbd>E</kbd> | Jump to start / end of line | zsh |
| <kbd>Ctrl</kbd> + <kbd>W</kbd> | Delete the previous word | zsh |
| <kbd>Ctrl</kbd> + <kbd>U</kbd> | Delete the whole line | zsh |
| <kbd>Ctrl</kbd> + <kbd>L</kbd> | Clear the screen | zsh |

## Alacritty

| Keys | What it does |
|------|--------------|
| <kbd>Shift</kbd> + <kbd>Enter</kbd> | New line without running the command (handy in Claude Code) |
| <kbd>Option</kbd> | Works as <kbd>Alt</kbd> (both sides) |
| Select text | Copied to clipboard automatically |

## Commands and aliases

| Type | Runs | What it does |
|------|------|--------------|
| `ls` / `l` / `la` / `lla` | `lsd` | Colorful file lists with icons |
| `lt` | `lsd --tree` | Folder tree |
| `z <name>` | z | Jump to a folder you visit often |
| `google <query>` | web-search | Search Google from the terminal |
| `gst` | `git status` | oh-my-zsh git alias |
| `gaa` | `git add --all` | oh-my-zsh git alias |
| `gcmsg "msg"` | `git commit -m` | oh-my-zsh git alias |
| `gp` | `git push` | oh-my-zsh git alias |
| `lazygit` | lazygit | Git in a nice terminal UI |
| `btop` | btop | System monitor |
| `fastfetch` | fastfetch | System info with a logo |

Full list of git aliases: run `alias | grep git`.
