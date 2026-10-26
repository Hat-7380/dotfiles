#!/usr/bin/env bash
# ff: compact fastfetch that cycles through ~/.config/fastfetch/images/1.png, 2.png, ...
# Each image has its own size/position below. If one looks wrong, fix only its line.
#
#   N   height  top  left  right  down
#   height = image height in terminal lines, top = lines above the image
#   (raise top to move it down, lower to move it up), left/right = side gaps,
#   down = blank lines added above the info text (pushes the text down)
#
# Usage:  ff        next image in the loop
#         ff 3      show image 3 (doesn't change the loop)
#         ff ascii  show ASCII art from ~/.config/fastfetch/ascii/ (ff ascii 2 = number 2)
dir="$HOME/.config/fastfetch"
state="$HOME/.cache/ff-image-index"

# Colour text art line by line with the Catppuccin Frappe gradient (pink -> teal)
gradient() {
  awk 'BEGIN { split("244 184 228 202 158 230 140 170 238 133 193 220 129 200 190", s, " ") }
       { l[NR] = $0 }
       END { for (i = 1; i <= NR; i++) {
               t = (NR > 1 ? (i - 1) / (NR - 1) : 0) * 4; a = int(t); if (a > 3) a = 3; f = t - a
               for (k = 0; k < 3; k++) c[k] = int(s[a*3+k+1] + (s[(a+1)*3+k+1] - s[a*3+k+1]) * f + 0.5)
               printf "\033[38;2;%d;%d;%dm%s\033[0m\n", c[0], c[1], c[2], l[i] } }' "$1"
}

read -r -d '' table <<'TABLE'
1  11  2  2  2  0
2  14  2  10  7  2
3  11  2  6  4  0
4  0  1  2  4  2
5  11  2  6  4  0
6  14  3  8  5  3
TABLE

count=$(printf '%s\n' "$table" | wc -l)

if [[ "$1" == ascii ]]; then
  a="${2:-1}"; f="$dir/ascii/$a.txt"
  [[ -f "$f" ]] || { echo "ff: no ASCII file $f" >&2; exit 1; }
  tmp="$HOME/.cache/ff-ascii-current.jsonc"; art="$HOME/.cache/ff-ascii-art.txt"
  mkdir -p "${tmp%/*}"
  gradient "$f" > "$art"
  sed "s|ASCIIFILE|$art|" "$dir/ff-ascii.jsonc" > "$tmp"
  exec fastfetch --config "$tmp"
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
  n=$1
else
  last=$(cat "$state" 2>/dev/null)
  [[ "$last" =~ ^[0-9]+$ ]] || last=0
  n=$(( last % count + 1 ))
  mkdir -p "${state%/*}" && echo "$n" > "$state"
fi

read -r _ h t l r o < <(printf '%s\n' "$table" | awk -v n="$n" '$1==n')
if [[ -z "$h" || ( ! -f "$dir/images/$n.png" && ! -f "$dir/images/$n.txt" ) ]]; then
  echo "ff: no image $n (have 1-$count)" >&2; exit 1
fi

# Text picture: images/N.txt is shown as text with the Frappe gradient instead of an image.
if [[ -f "$dir/images/$n.txt" && ! -f "$dir/images/$n.png" ]]; then
  tmp="$HOME/.cache/ff-current.jsonc"; art="$HOME/.cache/ff-ascii-art.txt"
  mkdir -p "${tmp%/*}"
  gradient "$dir/images/$n.txt" > "$art"
  sed -e "s|ASCIIFILE|$art|" \
      -e "s|\"padding\": {[^}]*}|\"padding\": { \"top\": $t, \"left\": $l, \"right\": $r }|" \
      "$dir/ff-ascii.jsonc" > "$tmp"
  for ((i = 0; i < ${o:-0}; i++)); do
    sed -i 's|^  "modules": \[|&\n    "break",|' "$tmp"
  done
  exec fastfetch --config "$tmp"
fi

# Build a temp config from ff.jsonc with this image's settings (same format that
# is known to work), then run fastfetch on it.
tmp="$HOME/.cache/ff-current.jsonc"
mkdir -p "${tmp%/*}"
sed -e "s|\"source\": \"[^\"]*\"|\"source\": \"$dir/images/$n.png\"|" \
    -e "s|\"height\": [0-9]*|\"height\": $h|" \
    -e "s|\"padding\": {[^}]*}|\"padding\": { \"top\": $t, \"left\": $l, \"right\": $r }|" \
    "$dir/ff.jsonc" > "$tmp"
for ((i = 0; i < ${o:-0}; i++)); do
  sed -i 's|^  "modules": \[|&\n    "break",|' "$tmp"
done
exec fastfetch --config "$tmp"
