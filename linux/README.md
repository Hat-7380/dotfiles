# 🐧 Linux

Coming soon: my Linux setup (distro, desktop/window manager, keybindings, and system-specific configs).

The shared configs in this repo (zsh, bash, Alacritty, btop, VS Code) already work on Linux. `install.sh` links them to the right places.

To install the CLI tools on Linux, either use [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux) with the `Brewfile`, or your distro's package manager:

```bash
# Debian / Ubuntu
sudo apt install zsh git fzf bat fd-find btop
# Arch
sudo pacman -S zsh git fzf bat fd btop lsd eza lazygit git-delta starship fastfetch
```
