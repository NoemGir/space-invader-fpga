from PIL import Image, ImageFont, ImageDraw

FONT_FILE = "Binnacle.ttf"
FONT_SIZE = 8
CHARS = "h"

font = ImageFont.truetype(FONT_FILE, FONT_SIZE)

with open("alphabet_fonts.txt", "w") as f:
    i = 0
    for c in CHARS:
        img = Image.new("1", (8, 8), 0)
        draw = ImageDraw.Draw(img)
        draw.text((0, 0), c, font=font, fill=1)

        f.write(f"font_mem64[{i}]  = 64'h")

        for y in range(8):
            row = 0
            for x in range(8):
                row <<= 1
                row |= img.getpixel((x, y))
            f.write(f"{row:02X}")

        f.write(f"; //{c}\n")
        i += 1
