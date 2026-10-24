# ─────────────────────────────────────────────────────────────
#  ~/.zprofile (runs once at login, before .zshrc)
# ─────────────────────────────────────────────────────────────

# Python 3.14 (python.org installer)
if [[ -d /Library/Frameworks/Python.framework/Versions/3.14/bin ]]; then
  PATH="/Library/Frameworks/Python.framework/Versions/3.14/bin:${PATH}"
  export PATH
fi

# Homebrew (Apple Silicon Mac, or Linuxbrew)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
