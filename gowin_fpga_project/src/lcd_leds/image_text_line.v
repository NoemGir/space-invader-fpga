
module text_line
#(
    parameter TEXT_X0 = 0,
    parameter TEXT_Y0 = 0,
    parameter SCALE = 3,
    parameter TEXT_SIZE = 18,
    parameter CHAR_SIZE = 8,
    parameter COLOR = 'hffffff
)
(
	input  wire			clk,	
	input  wire			rst_n,	
	input  wire	[11:0]	lcd_xpos,
	input  wire	[11:0]	lcd_ypos,
    input  wire         enable,

    input  logic [5:0] text_buf [0:TEXT_SIZE-1],
    
    output wire [23:0] word_pixel,
    output wire pixel_valid
);


`define RGB565(R,G,B) {3'b0, R, 2'b0, G, 3'b0, B}
`define BACKGROUND `RGB565(5'd3, 6'd3, 5'd7)


reg [63:0] font_mem64 [0:39];  // 40 characters

initial begin
    font_mem64[0]  = 64'h1C22414141221C00; //0
    font_mem64[1]  = 64'h0C14040404040400; //1
    font_mem64[2]  = 64'h3E41010E30407F00; //2
    font_mem64[3]  = 64'h7F02041E01413E00; //3
    font_mem64[4]  = 64'h0E1222427F020200; //4
    font_mem64[5]  = 64'h7F40407E01413E00; //5
    font_mem64[6]  = 64'h3E41407E41413E00; //6
    font_mem64[7]  = 64'h3F41020408102000; //7
    font_mem64[8]  = 64'h3E41413E41413E00; //8
    font_mem64[9]  = 64'h3E41413F01413E00; //9
    font_mem64[10]  = 64'h00003E4242423D00; //a
    font_mem64[11]  = 64'h40407C4242427C00; //b
    font_mem64[12]  = 64'h00003E4040403E00; //c
    font_mem64[13]  = 64'h02023E4242423E00; //d
    font_mem64[14]  = 64'h00003C427E403E00; //e
    font_mem64[15]  = 64'h0E10107C10101000; //f
    font_mem64[16]  = 64'h10107C1010100E00; //t
    font_mem64[17]  = 64'h00003E42423E023C; //g
    font_mem64[18]  = 64'h1000101010100C00; //i
    font_mem64[19]  = 64'h0400040404044438; //j
    font_mem64[20]  = 64'h2020222438242200; //k
    font_mem64[21]  = 64'h1010101010100C00; //l
    font_mem64[22]  = 64'h0000774949494900; //m
    font_mem64[23]  = 64'h00007C4242424200; //n
    font_mem64[24]  = 64'h00003C4242423C00; //o
    font_mem64[25]  = 64'h00007C42427C4040; //p
    font_mem64[26]  = 64'h00003E42423E0202; //q
    font_mem64[27]  = 64'h00007C4240404000; //r
    font_mem64[28]  = 64'h00003E403C027C00; //s
    font_mem64[29]  = 64'h10107C1010100E00; //t
    font_mem64[30]  = 64'h0000424242423C00; //u
    font_mem64[31]  = 64'h0000424244483000; //v
    font_mem64[32]  = 64'h0000494949497700; //w
    font_mem64[33]  = 64'h0000422418244200; //x
    font_mem64[34]  = 64'h00004242423E023C; //y
    font_mem64[35]  = 64'h00007E0418207E00; //z
    font_mem64[36]  = 64'h40407C4242424200; //h
    font_mem64[37]  = 64'h0000007E00000000; //-
    font_mem64[38] = 64'h669981814222120C; // heart character
    font_mem64[39]  = 64'h0000000000000000; // 
end

reg [CHAR_SIZE-1:0] font_row;

reg [23:0] lcd_data;
reg valid;

assign word_pixel = lcd_data;
assign pixel_valid = valid;

reg signed [11:0] position_x;
reg signed [11:0] position_y;

reg [7:0] char_y;
reg [7:0] char_index_buf;

reg [2:0] font_x;
reg [2:0] font_y;

reg inside_text;

reg [5:0] char_index_mem;

always_comb begin 
    font_row = 8'd0;
    lcd_data = `BACKGROUND;
    valid = 1'b0;
    font_x = 3'd0;
    font_y = 3'd0;
    char_y = 8'd0;
    char_index_buf = 8'd0;
    char_index_mem = 6'd0;

    position_x = ($signed({1'b0, lcd_xpos}) - $signed({1'b0,TEXT_X0}));
    position_y = ($signed({1'b0, lcd_ypos}) - $signed({1'b0, TEXT_Y0}));

    inside_text =
        enable &&
        (position_x >= 0 && position_x < CHAR_SIZE * SCALE) &&
        (position_y >= 0 && position_y < TEXT_SIZE * CHAR_SIZE * SCALE);

    if(inside_text) begin

        font_x = (position_x / SCALE);
        font_y = (position_y / SCALE) % CHAR_SIZE;
        
        char_y = position_y / (CHAR_SIZE*SCALE);
        char_index_buf = TEXT_SIZE - 1 - char_y;

        char_index_mem = text_buf[char_index_buf];
        font_row = font_mem64[char_index_mem][63 - font_x*8 -: 8];

        if(font_row[font_y]) begin
            valid = 1'b1;
            lcd_data <= COLOR;
       end
    end
end



endmodule
