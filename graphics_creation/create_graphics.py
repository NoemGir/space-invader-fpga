def ascii_to_verilog(ascii_art):
    """
    Converts ASCII art to Verilog case statements for each pixel.
    Characters mapping:
        ' ' -> not valid
        '■' -> CAT_BLACK
        '_' -> CAT_WHITE
        'x' -> CAT_GRAY
        '*' -> CAT_PINK
    """
    # Split ASCII art into lines and reverse to match y_coord = 1 at top
    lines = ascii_art.splitlines()
    height = len(lines)
    width = max(len(line) for line in lines)
    
    # Pad lines to equal width
    lines = [line.ljust(width) for line in lines]
    
    # Start generating Verilog
    verilog = []
    verilog.append("case (y_coord)")
    
    for x_idx in range(width):
        verilog.append(f"    {x_idx+1}: case (x_coord)")
        for y_idx in range(height):
            char = lines[y_idx][x_idx]
            if char == '■':
                color = '`CAT_BLACK'
            elif char == '_':
                color = '`CAT_WHITE'
            elif char == 'x':
                color = '`CAT_GRAY'
            elif char == '*':
                color = '`CAT_PINK'
            else:
                continue  # skip empty pixels
            
            verilog.append(f"        {y_idx+1}: begin lcd_data <= {color}; valid <= 1'b1; end")
        verilog.append("    endcase")
    
    verilog.append("endcase")
    return "\n".join(verilog)

# Example usage
ascii_art = """
   ■■     ■■
   ■x■   ■*■
   ■xx■■■**■
  ■xxxx__***
  ■xxx____**
x ■___■__■__
_ ■___■__■__
 __■_______■
■***_■■■■■■
■*___xxx___■
■__________■
■_■_■■■■_■_■
"""            
verilog_code = ascii_to_verilog(ascii_art)
print(verilog_code)