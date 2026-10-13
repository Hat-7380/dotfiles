import math, sys
from PIL import Image, ImageDraw
out = sys.argv[1]
S, N = 4, 640                      # supersample, output size
W = N * S
img = Image.new("RGBA", (W, W), (0, 0, 0, 0))
d = ImageDraw.Draw(img)
c = W / 2
orange = (217, 119, 87, 255)       # Claude clay
# ray angle offsets (deg) and lengths (fraction of radius), irregular like the spark
lengths = [1.00, 0.72, 0.93, 0.66, 0.98, 0.78, 0.90, 0.68, 1.00, 0.74, 0.95, 0.70,
           0.88, 0.76]
n = len(lengths)
R = W * 0.46
for i, L in enumerate(lengths):
    a = math.radians(-90 + i * 360 / n + (4 if i % 2 else -3))
    x, y = c + math.cos(a) * R * L, c + math.sin(a) * R * L
    wid = int(W * (0.050 if L > 0.85 else 0.044))
    d.line([(c, c), (x, y)], fill=orange, width=wid)
    r = wid / 2
    d.ellipse([x - r, y - r, x + r, y + r], fill=orange)   # round tip
r = W * 0.05
d.ellipse([c - r, c - r, c + r, c + r], fill=orange)
img = img.resize((N, N), Image.LANCZOS)
img.save(out)
print("saved", out, img.size)
