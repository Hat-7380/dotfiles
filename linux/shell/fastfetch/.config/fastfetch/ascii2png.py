#!/usr/bin/env python3
"""Render a braille/ASCII text file to a gradient PNG (transparent bg) using the same
font kitty uses. Usage: ascii2png.py in.txt out.png [height_px]"""
import sys, os
from PIL import Image, ImageDraw, ImageFont
src, dst = sys.argv[1], sys.argv[2]
# Catppuccin Frappe gradient pink -> mauve -> blue -> sapphire -> teal, top to bottom
STOPS = [(244,184,228), (202,158,230), (140,170,238), (133,193,220), (129,200,190)]
def color_at(i, n):
    t = i / max(n - 1, 1) * (len(STOPS) - 1); a = min(int(t), len(STOPS) - 2); f = t - a
    return tuple(round(STOPS[a][k] + (STOPS[a + 1][k] - STOPS[a][k]) * f) for k in range(3)) + (255,)
height = int(sys.argv[3]) if len(sys.argv) > 3 else 900
font = ImageFont.truetype(os.path.expanduser(
    '~/.local/share/fonts/JetBrainsMonoNerd/JetBrainsMonoNerdFontMono-Regular.ttf'), 48)
lines = open(src, encoding='utf-8').read().rstrip('\n').split('\n')
asc, desc = font.getmetrics(); lh = asc + desc
cw = font.getlength('⣿')
im = Image.new('RGBA', (int(cw * max(len(l) for l in lines)) + 4, lh * len(lines) + 4), (0, 0, 0, 0))
dr = ImageDraw.Draw(im)
for i, l in enumerate(lines):
    dr.text((2, 2 + i * lh), l, font=font, fill=color_at(i, len(lines)))
im = im.crop(im.getbbox())
pad = 16
out = Image.new('RGBA', (im.width + 2 * pad, im.height + 2 * pad), (0, 0, 0, 0))
out.paste(im, (pad, pad))
out = out.resize((round(out.width * height / out.height), height), Image.LANCZOS)
out.save(dst)
print(dst, out.size)
