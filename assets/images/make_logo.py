from PIL import Image, ImageDraw, ImageFont
import math, os

SIZE = 1024
EMERALD = (11, 61, 46)
EMERALD2 = (27, 107, 80)
GOLD = (212, 175, 55)
GOLD_BRIGHT = (244, 217, 123)
CREAM = (251, 248, 241)

img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)
cx, cy = SIZE // 2, SIZE // 2
radius = SIZE // 2 - 30

# خلفية دائرية متدرجة (من زمردي إلى أغمق)
for i in range(radius, 0, -2):
    t = i / radius
    r = int(EMERALD[0] * t + EMERALD2[0] * (1 - t))
    g = int(EMERALD[1] * t + EMERALD2[1] * (1 - t))
    b = int(EMERALD[2] * t + EMERALD2[2] * (1 - t))
    draw.ellipse([cx - i, cy - i, cx + i, cy + i], fill=(r, g, b))

# إطار ذهبي خارجي
draw.ellipse([cx - radius, cy - radius, cx + radius, cy + radius],
             outline=GOLD, width=16)

# إطار ذهبي داخلي رقيق
r2 = radius - 28
draw.ellipse([cx - r2, cy - r2, cx + r2, cy + r2],
             outline=GOLD_BRIGHT, width=3)

# نجمة ثمانية إسلامية (نجمة الملك سليمان المبسطة)
def star8(cx, cy, r1, r2, color):
    pts = []
    for i in range(16):
        angle = math.pi / 8 * i - math.pi / 2
        rr = r1 if i % 2 == 0 else r2
        pts.append((cx + rr * math.cos(angle), cy + rr * math.sin(angle)))
    draw.polygon(pts, fill=color)

# زخارف صغيرة في الأعلى
star8(cx, cy - 320, 30, 14, GOLD)
star8(cx - 400, cy - 100, 20, 10, GOLD)
star8(cx + 400, cy - 100, 20, 10, GOLD)
star8(cx - 400, cy + 300, 18, 8, GOLD)
star8(cx + 400, cy + 300, 18, 8, GOLD)

# هلال ذهبي
moon_r = 130
moon_x, moon_y = cx, cy - 130
draw.ellipse([moon_x - moon_r, moon_y - moon_r,
              moon_x + moon_r, moon_y + moon_r], fill=GOLD)
draw.ellipse([moon_x - moon_r + 50, moon_y - moon_r,
              moon_x + moon_r + 50, moon_y + moon_r], fill=EMERALD)

# نص "القرآن الكريم" - نحاول إيجاد خط عربي
arabic_text = "القرآن الكريم"
english_text = "THE HOLY QURAN"

# ابحث عن خط عربي متوفر
font_ar_paths = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    "/usr/share/fonts/truetype/freefont/FreeSansBold.ttf",
]
font_en_paths = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
]
# ابحث عن خطوط أميري إن وُجدت
for root, dirs, files in os.walk("/usr/share/fonts"):
    for f in files:
        if "Amiri" in f and f.endswith(".ttf"):
            font_ar_paths.insert(0, os.path.join(root, f))
        if "Noto" in f and "Arabic" in f and f.endswith(".ttf"):
            font_ar_paths.insert(0, os.path.join(root, f))

def load_font(paths, size):
    for p in paths:
        try:
            return ImageFont.truetype(p, size)
        except Exception:
            continue
    return ImageFont.load_default()

font_ar = load_font(font_ar_paths, 90)
font_en = load_font(font_en_paths, 36)

# النص العربي في الأسفل
bbox = draw.textbbox((0, 0), arabic_text, font=font_ar)
tw = bbox[2] - bbox[0]
draw.text((cx - tw // 2, cy + 240), arabic_text, font=font_ar, fill=GOLD_BRIGHT)

# النص الإنجليزي تحته
bbox2 = draw.textbbox((0, 0), english_text, font=font_en)
tw2 = bbox2[2] - bbox2[0]
draw.text((cx - tw2 // 2, cy + 350), english_text, font=font_en, fill=GOLD)

img.save("logo.png", "PNG")
print("✅ logo.png created")
