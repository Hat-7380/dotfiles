#!/usr/bin/env bash
# Catppuccin Frappe minimal status line. Style: first arg, else ~/.claude/statusline.style, else "whisper".
# Styles: whisper | dots | gradient | line | pills
in=$(cat)
style=${1:-$(cat ~/.claude/statusline.style 2>/dev/null)}; style=${style:-whisper}

# Right-align: re-run ourselves, measure the visible width, pad on the left.
if [ -z "$_SL_INNER" ]; then
  out=$(_SL_INNER=1 "$0" "$style" <<<"$in")
  cols=$({ stty size </dev/tty; } 2>/dev/null | cut -d' ' -f2)
  if [ -z "$cols" ]; then  # no controlling tty: borrow the terminal of an ancestor process
    pid=$$
    for _ in 1 2 3 4 5 6 7 8; do
      pid=$(awk '{print $4}' /proc/$pid/stat 2>/dev/null)
      [ -z "$pid" ] || [ "$pid" -le 1 ] && break
      for fd in 0 1 2; do
        t=$(readlink /proc/$pid/fd/$fd 2>/dev/null)
        case "$t" in /dev/pts/*) cols=$({ stty size <"$t"; } 2>/dev/null | cut -d' ' -f2); break 2 ;; esac
      done
    done
  fi
  cols=${cols:-${COLUMNS:-0}}
  [ -z "$out" ] && exit 0
  vis=$(sed 's/\x1b\[[0-9;]*m//g' <<<"$out" | head -1 | LC_ALL=C.UTF-8 wc -m)
  vis=$((vis - 1))
  pad=$((cols - vis - 1))
  echo "$(date +%T) cols=${cols:-none} vis=$vis pad=$pad" >> ~/.claude/statusline.log
  # right-align off (backup: statusline.sh.before-leftalign)
  # [ "$pad" -gt 0 ] && printf '\u2800%.0s' $(seq 1 "$pad")
  printf '%s' "$out"
  exit 0
fi

j() { jq -r "$1 // empty" <<<"$in" 2>/dev/null; }

model=$(j '.model.display_name')
dir=$(j '.workspace.current_dir'); [ -z "$dir" ] && dir=$(j '.cwd')
cost=$(j '.cost.total_cost_usd')
ms=$(j '.cost.total_duration_ms')
pct=$(j '.context_window.used_percentage')
added=$(j '.cost.total_lines_added')
removed=$(j '.cost.total_lines_removed')

rgb() { printf '%d;%d;%d' "$((16#${1:0:2}))" "$((16#${1:2:2}))" "$((16#${1:4:2}))"; }
fg() { printf '\033[38;2;%sm' "$(rgb $1)"; }
R=$'\033[0m'
PINK=f4b8e4 MAUVE=ca9ee6 BLUE=8caaee SAPPHIRE=85c1dc TEAL=81c8be
GREEN=a6d189 YELLOW=e5c890 RED=e78284 INK=303446 DIM=626880 SUB=a5adce TEXT=c6d0f5

short=""; br=""; dirty=""
if [ -n "$dir" ]; then
  short="${dir/#$HOME/~}"
  [ "$(tr -cd '/' <<<"$short" | wc -c)" -gt 2 ] && short="…/$(awk -F/ '{print $(NF-1)"/"$NF}' <<<"$short")"
  br=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  if [ -n "$br" ]; then
    nchg=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l)
    [ "$nchg" -gt 0 ] && dirty=1
    ab=$(git -C "$dir" rev-list --left-right --count '@{u}...HEAD' 2>/dev/null)
    behind=${ab%%[[:space:]]*}; ahead=${ab##*[[:space:]]}
  fi
fi
p=""; ctxcol=$SAPPHIRE
if [ -n "$pct" ]; then
  p=${pct%.*}; [ -z "$p" ] && p=0
  [ "$p" -ge 60 ] && ctxcol=$YELLOW; [ "$p" -ge 85 ] && ctxcol=$RED
fi
t=""
if [ -n "$ms" ]; then
  s=$(( ${ms%.*} / 1000 ))
  if [ "$s" -ge 3600 ]; then t="$((s/3600))h$(( s%3600/60 ))m"; elif [ "$s" -ge 60 ]; then t="$((s/60))m"; else t="${s}s"; fi
fi
c=""; [ -n "$cost" ] && c=$(printf '$%.2f' "$cost")

join() { local sep="$1"; shift; local o="" x; for x in "$@"; do [ -z "$x" ] && continue; o+="${o:+$sep}$x"; done; printf '%s' "$o"; }

case "$style" in
whisper)  # quiet grey text, one soft accent on the model
  sep="$(fg $DIM) · $R"
  parts=()
  [ -n "$model" ] && parts+=("$(fg $PINK)$model$R")
  [ -n "$short" ] && parts+=("$(fg $SUB)$short$R")
  [ -n "$br" ] && parts+=("$(fg $SUB)$br$([ -n "$dirty" ] && printf '%s' "$(fg $YELLOW)*")$R")
  [ -n "$p" ] && parts+=("$(fg $ctxcol)${p}%$R")
  [ -n "$c" ] && parts+=("$(fg $SUB)$c$R")
  join "$sep" "${parts[@]}" ;;
dots)     # a coloured dot per item, text stays soft
  parts=()
  [ -n "$model" ] && parts+=("$(fg $PINK)● $(fg $TEXT)$model$R")
  [ -n "$short" ] && parts+=("$(fg $MAUVE)● $(fg $SUB)$short$R")
  [ -n "$br" ] && parts+=("$(fg $BLUE)● $(fg $SUB)$br$([ -n "$dirty" ] && printf '%s' "$(fg $YELLOW)*")$R")
  [ -n "$p" ] && parts+=("$(fg $ctxcol)● $(fg $SUB)${p}%$R")
  [ -n "$t" ] && parts+=("$(fg $TEAL)● $(fg $SUB)$t$R")
  join "   " "${parts[@]}" ;;
gradient) # each item takes the next colour of the pink→teal gradient, thin slashes between
  cols=($PINK $MAUVE $BLUE $SAPPHIRE $TEAL); items=()
  [ -n "$model" ] && items+=("$model")
  [ -n "$short" ] && items+=("$short")
  [ -n "$br" ] && items+=("$br$([ -n "$dirty" ] && printf '*')")
  [ -n "$p" ] && items+=("${p}%")
  [ -n "$c" ] && items+=("$c")
  o=""; for i in "${!items[@]}"; do o+="${o:+$(fg $DIM)  ╱  }$(fg ${cols[$((i%5))]})${items[$i]}"; done
  printf '%s%s' "$o" "$R" ;;
line)     # model on the left, a thin gradient context line, nothing else
  [ -z "$p" ] && p=0
  w=16; f=$(( (p * w + 50) / 100 )); cols=($PINK $MAUVE $BLUE $SAPPHIRE $TEAL)
  bar=""; for i in $(seq 0 $((w-1))); do
    if [ "$i" -lt "$f" ]; then bar+="$(fg ${cols[$((i*5/w))]})━"; else bar+="$(fg $DIM)─"; fi
  done
  printf '%s%s%s  %s  %s%s%%%s' "$(fg $PINK)" "$model" "$R" "$bar" "$(fg $SUB)" "$p" "$R" ;;
mix)      # gradient items, then the thin context line with its percentage
  cols=($PINK $MAUVE $BLUE $SAPPHIRE $TEAL); items=()
  [ -n "$model" ] && items+=("$model")
  [ -n "$short" ] && items+=("$short")
  [ -n "$br" ] && items+=("$br$([ -n "$dirty" ] && printf '*')")
  [ -n "$c" ] && items+=("$c")
  [ -n "$t" ] && items+=("$t")
  o=""; for i in "${!items[@]}"; do o+="${o:+$(fg $DIM)  ╱  }$(fg ${cols[$((i%5))]})${items[$i]}"; done
  pp=${p:-0}; w=12; f=$(( (pp * w + 50) / 100 )); bar=""
  for i in $(seq 0 $((w-1))); do
    if [ "$i" -lt "$f" ]; then bar+="$(fg ${cols[$((i*5/w))]})━"; else bar+="$(fg $DIM)─"; fi
  done
  printf '%s   %s  %s%s%%%s' "$o" "$bar" "$(fg $ctxcol)" "$pp" "$R" ;;
pills)    # soft rounded pills, no arrows
  parts=(); pill() { parts+=("\033[38;2;$(rgb $1)m"$''"\033[48;2;$(rgb $1);38;2;$(rgb $INK)m $2 \033[0m\033[38;2;$(rgb $1)m"$''"\033[0m"); }
  [ -n "$model" ] && pill $PINK "$model"
  [ -n "$short" ] && pill $MAUVE "$short"
  if [ -n "$br" ]; then
    g="$br"
    [ "${ahead:-0}" -gt 0 ] && g+=" ↑$ahead"
    [ "${behind:-0}" -gt 0 ] && g+=" ↓$behind"
    [ "${nchg:-0}" -gt 0 ] && g+=" ~$nchg"
    pill $BLUE "$g"
  fi
  [ -n "$p" ] && pill $ctxcol "${p}%"
  [ -n "$t" ] && pill $TEAL "$t"
  [ -n "$c" ] && pill $GREEN "$c"
  { [ "${added:-0}" -gt 0 ] || [ "${removed:-0}" -gt 0 ]; } && pill $YELLOW "+${added:-0} -${removed:-0}"
  o=""; for x in "${parts[@]}"; do o+="${o:+ }$x"; done; printf '%b' "$o" ;;
esac
