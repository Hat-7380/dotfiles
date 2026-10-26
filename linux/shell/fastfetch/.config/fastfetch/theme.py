#!/usr/bin/env python3
"""Regenerates ff.jsonc, ff-ascii.jsonc, config.jsonc (intro) and clawd.txt in one
Catppuccin Frappe theme. Edit the palette/gradient here, run `python3 -I theme.py`."""
import os
d = os.path.expanduser('~/.config/fastfetch/')

P = dict(rosewater=(242,213,207), flamingo=(238,190,190), pink=(244,184,228), mauve=(202,158,230),
         red=(231,130,132), peach=(239,159,118), yellow=(229,200,144), green=(166,209,137),
         teal=(129,200,190), sky=(153,209,219), sapphire=(133,193,220), blue=(140,170,238),
         lavender=(186,187,241), text=(198,208,245), overlay1=(131,139,167))
STOPS = [P['pink'], P['mauve'], P['blue'], P['sapphire'], P['teal']]   # main gradient

def grad(n):
    """n colours spread along STOPS."""
    out = []
    for i in range(n):
        t = i / (n - 1) * (len(STOPS) - 1) if n > 1 else 0
        a = min(int(t), len(STOPS) - 2); f = t - a
        out.append(tuple(round(STOPS[a][k] + (STOPS[a + 1][k] - STOPS[a][k]) * f) for k in range(3)))
    return out

def c(rgb): return "38;2;%d;%d;%d" % rgb

def module(typ, key, color, extra=""):
    return '    { "type": "%s", "key": "{icon} %s", "keyColor": "%s", "outputColor": "%s"%s }' % (
        typ, key, c(color), c(P['text']), extra)

display = '''  "display": {
    "separator": " › ",
    "key": { "width": 7 },
    "color": { "separator": "%s", "output": "%s" },
    "percent": { "color": { "green": "%s", "yellow": "%s", "red": "%s" } }
  },''' % (c(P['overlay1']), c(P['text']), c(P['green']), c(P['yellow']), c(P['red']))

SCHEMA = '  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",'

# ---- ff (full compact) ----
rows = [('os', 'OS'), ('kernel', 'KER'), ('packages', 'PKG'), ('shell', 'SH'),
        ('terminal', 'TER'), ('de', 'DE'), ('uptime', 'UP'), ('memory', 'MEM')]
g = grad(len(rows))
mods = ',\n'.join(module(t, k, g[i]) for i, (t, k) in enumerate(rows))
dots = ' '.join('{#%s}●{#}' % c(P[n]) for n in
                ['rosewater', 'flamingo', 'pink', 'mauve', 'red', 'peach', 'yellow', 'green', 'teal', 'sky', 'blue', 'lavender'])
title = '    { "type": "title", "color": { "user": "%s", "at": "%s", "host": "%s" } }' % (
    c(P['pink']), c(P['overlay1']), c(P['blue']))
modules = '''  "modules": [
    "break",
%s,
    "break",
%s,
    "break",
    { "type": "custom", "format": "%s" }
  ]''' % (title, mods, dots)

def logo_image():
    return '''  "logo": {
    "type": "kitty",
    "source": "~/.config/fastfetch/images/1.png",
    "height": 11,
    "padding": { "top": 2, "left": 2, "right": 3 }
  },'''
def logo_text():
    return '''  "logo": {
    "type": "file-raw",
    "source": "ASCIIFILE",
    "padding": { "top": 1, "left": 2, "right": 3 }
  },'''

def write(name, logo, mods_block):
    open(d + name, 'w').write('{\n%s\n%s\n%s\n%s\n}\n' % (SCHEMA, logo, display, mods_block))

write('ff.jsonc', logo_image(), modules)
write('ff-ascii.jsonc', logo_text(), modules)

# ---- intro ----
irows = [('os', 'OS'), ('kernel', 'KER'), ('shell', 'SH'), ('memory', 'MEM')]
ig = grad(5)
imods = ',\n'.join(module(t, k, ig[i]) for i, (t, k) in enumerate(irows))
imods += ',\n' + module('command', 'CLD', ig[4], ', "text": "claude-usage"')
intro_mods = '''  "modules": [
    "break",
%s,
    "break"
  ]''' % imods
intro_logo = '''  "logo": {
    "type": "file-raw",
    "source": "~/.config/fastfetch/clawd.txt",
    "padding": { "top": 2, "left": 2, "right": 3 }
  },'''
write('config.jsonc', intro_logo, intro_mods)

# ---- Clawd (Claude mascot) in the gradient ----
art = [' ▐▛███▜▌ ', '▝▜█████▛▘', '  ▘▘ ▝▝  ']
cg = grad(3)
open(d + 'clawd.txt', 'w').write('\n'.join('\x1b[%sm%s\x1b[0m' % (c(cg[i]), l) for i, l in enumerate(art)) + '\n')
print('theme written')
