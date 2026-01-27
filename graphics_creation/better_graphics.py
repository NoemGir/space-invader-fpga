from PIL import Image
import os

def rgb888_to_lcd_rgb(rgb):
    r, g, b = rgb

    # Convert 8-bit RGB to RGB565 first
    r5 = (r >> 3) & 0x1F  # 5 bits
    g6 = (g >> 2) & 0x3F  # 6 bits
    b5 = (b >> 3) & 0x1F  # 5 bits

    # Pack into 21-bit layout for lcd_rgb
    lcd_rgb = (r5 << 16) | (g6 << 8) | b5
    return lcd_rgb

def image_to_verilog(image_path, frame):
    img = Image.open("image_refs/" + image_path).convert("RGB")
    width, height = img.size

    pixels = img.load()

    # Collect unique colors
    color_map = {}
    color_defs = []
    color_index = 1

    for y in range(height):
        for x in range(width):
            rgb = pixels[x, y]
            if rgb not in color_map:
                rgb21 = rgb888_to_lcd_rgb(rgb)
                name = f"`{frame}_COLOR_{color_index}"
                color_map[rgb] = name
                color_defs.append(
                     f"`define {frame}_COLOR_{color_index}   21'h{rgb21:05X}"
                )
                color_index += 1

    # Generate Verilog
    verilog = []
    verilog.extend(color_defs)
    verilog.append("")
    verilog.append(f"""reg valid_{frame};
reg [23:0] lcd_data_{frame};

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_data_{frame} <= `GREEN_BAD;
        valid_{frame} <= 1'b0;
    end else begin
        lcd_data_{frame} <= `GREEN_BAD;
        valid_{frame} <= 1'b0;
        if (inside_sprite && enable_frame{frame[1]}) begin
            valid_{frame} <= 1'b0;""")
    verilog.append("            case (y_coord)")

    for x_idx in range(width):
        verilog.append(f"               {x_idx+1}: case (x_coord)")

        # Group y positions by color
        color_groups = {}

        for y_idx in range(height):
            rgb = pixels[x_idx, y_idx]

            # Skip white pixels
            if rgb == (255, 255, 255):
                continue

            color = color_map[rgb]
            y_coord = y_idx + 1

            if color not in color_groups:
                color_groups[color] = []
            color_groups[color].append(y_coord)

        # Emit grouped cases
        for color, y_list in color_groups.items():
            y_list_str = ", ".join(str(y) for y in y_list)
            verilog.append(
                f"                  {y_list_str}: begin lcd_data_{frame} <= {color}; valid_{frame} <= 1'b1; end"
            )

        verilog.append("                endcase")

    verilog.append("            endcase")
    verilog.append("""        end
    end
end""")
    return "\n".join(verilog)


def process_image(image_path, frame):
    verilog_code = image_to_verilog(image_path, frame)
    base, _ = os.path.splitext(image_path)
    output_file = base + ".txt"

    with open( "results/" + output_file, "w") as f:
        f.write(verilog_code)

    print(f"Generated: {output_file}")


# Example usage
if __name__ == "__main__":
    process_image("frame_1.png", "F1")
    process_image("frame_2.png", "F2")
    process_image("frame_3.png", "F3")
    process_image("frame_4.png", "F4")
    process_image("frame_5.png", "F5")
    process_image("frame_6.png", "F6")
    process_image("nyan_cat.png", "C2")
    process_image("pika.png", "C3")



