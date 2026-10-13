# ─────────────────────────────────────────────────────────────
#  ~/.zshrc
# ─────────────────────────────────────────────────────────────

# Powerlevel10k instant prompt. Keep this near the top.
# Anything that needs console input (password prompts, y/n) must go above it.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh My Zsh ────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git                       # git aliases: gst, gco, gaa, gcmsg...
  zsh-autosuggestions       # grey suggestions from history, accept with →
  zsh-syntax-highlighting   # commands turn green/red as you type
  z                         # jump to frequent folders: z proj
  sudo                      # press Esc twice to add sudo
  web-search                # google "query" from the terminal
)

source $ZSH/oh-my-zsh.sh

# ── Prompt ───────────────────────────────────────────────────
# To customize the prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── Aliases ──────────────────────────────────────────────────
alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'

# ── PATH ─────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Functions ────────────────────────────────────────────────
# Run claude from ~/projects/work when launched from the home folder
# (home folder trust isn't remembered)
claude() {
  if [[ "$PWD" == "$HOME" ]]; then
    (cd ~/projects/work && command claude "$@")
  else
    command claude "$@"
  fi
}

# ── Local overrides (not tracked in git) ─────────────────────
# Put machine-specific settings or secrets in ~/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
