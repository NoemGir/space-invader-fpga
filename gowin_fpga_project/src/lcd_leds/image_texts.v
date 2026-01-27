
module image_texts
#(
    parameter CHAR_SIZE = 8,
    parameter MAX_SCORE = 9999

)
(
	input  wire			clk,	
	input  wire			rst_n,	
	input  wire	[11:0]	lcd_xpos,
	input  wire	[11:0]	lcd_ypos,
    input  wire         show_game_start,
    input  wire         show_game_over,

    input  wire [13:0]   score, // 9999 max 
    input  wire [13:0]   high_score, // 9999 max 
    
    output wire [23:0] text_pixel,
    output wire pixel_valid
);

localparam TITLE_SIZE = 18;
localparam TITLE_X0 = 381;
localparam TITLE_Y0 = 24;

localparam PLAY_SIZE = 4;
localparam PLAY_X0 = 300;
localparam PLAY_Y0 = 189;

localparam GAME_OVER_SIZE = 9;
localparam GAME_OVER_X0 = 171;
localparam GAME_OVER_Y0 = 99;
localparam SCALE_GAME_OVER = 4;

localparam SCORE_SIZE = 5;
localparam SCORE_X0 = 6;
localparam SCORE_Y0 = 300;

localparam SCORE_VALUE_SIZE = 4;
localparam SCORE_VALUE_X0 = 36;
localparam SCORE_VALUE_Y0 = 312;

localparam HIGH_SCORE_SIZE = 8;
localparam HIGH_SCORE_X0 = 6;
localparam HIGH_SCORE_Y0 = 45;

localparam HIGH_SCORE_VALUE_SIZE = 4;
localparam HIGH_SCORE_VALUE_X0 = 36;
localparam HIGH_SCORE_VALUE_Y0 = 90;

wire enable_title_screen = show_game_start;
wire enable_score = 1'b1;
wire enable_end_game_screen = show_game_over;


assign pixel_valid =
       title_pixel_valid |
       play_pixel_valid |
       game_over_pixel_valid |
       score_pixel_valid |
       score_value_pixel_valid |
       high_score_pixel_valid |
       high_score_value_pixel_valid;


assign text_pixel =
       title_pixel_valid           ? title_pixel :
       play_pixel_valid            ? play_pixel  :
       game_over_pixel_valid       ? game_over_pixel :
       score_pixel_valid           ? score_pixel :
       score_value_pixel_valid     ? score_value_pixel :
       high_score_pixel_valid      ? high_score_pixel :
       high_score_value_pixel_valid? high_score_value_pixel :
       24'b0;

// --------------- TITLE --------------------------

reg [5:0] title_buf [0:TITLE_SIZE-1];
wire title_pixel_valid;
wire [23:0]  title_pixel;

initial begin
    title_buf[0] = 28;
    title_buf[1] = 25;
    title_buf[2] = 10;
    title_buf[3] = 12;
    title_buf[4] = 14;
    title_buf[5] = 39;
    title_buf[6] = 12;
    title_buf[7] = 10;
    title_buf[8] = 16;
    title_buf[9] = 39;
    title_buf[10] = 18;
    title_buf[11] = 23;
    title_buf[12] = 31;
    title_buf[13] = 10;
    title_buf[14] = 13;
    title_buf[15] = 14;
    title_buf[16] = 27;
    title_buf[17] = 28;
end

text_line #(
    .TEXT_SIZE(TITLE_SIZE),
    .TEXT_X0(TITLE_X0),
    .TEXT_Y0(TITLE_Y0)

) title_line (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_title_screen),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
    .text_buf(title_buf),
	.word_pixel(title_pixel),	
	.pixel_valid(title_pixel_valid)
);

// --------------- PLAY --------------------------


reg [5:0] play_buf [0:PLAY_SIZE-1];
wire play_pixel_valid;
wire [23:0]  play_pixel;

initial begin
    play_buf[0] = 25;
    play_buf[1] = 21;
    play_buf[2] = 10;
    play_buf[3] = 34;
end

text_line #(
    .TEXT_SIZE(PLAY_SIZE),
    .TEXT_X0(PLAY_X0),
    .TEXT_Y0(PLAY_Y0)

) play_line (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_title_screen),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
    .text_buf(play_buf),
	.word_pixel(play_pixel),	
	.pixel_valid(play_pixel_valid)
);

// --------------- GAME OVER --------------------------

reg [5:0] game_over_buf [0:GAME_OVER_SIZE-1];
wire game_over_pixel_valid;
wire [23:0]  game_over_pixel;



initial begin
    game_over_buf[0] = 17;
    game_over_buf[1] = 10;
    game_over_buf[2] = 22;
    game_over_buf[3] = 14;
    game_over_buf[4] = 39;
    game_over_buf[5] = 24;
    game_over_buf[6] = 31;
    game_over_buf[7] = 14;
    game_over_buf[8] = 27;
end

text_line #(
    .TEXT_SIZE(GAME_OVER_SIZE),
    .TEXT_X0(GAME_OVER_X0),
    .TEXT_Y0(GAME_OVER_Y0),
    .SCALE(SCALE_GAME_OVER),
    .COLOR('hd60000)
) score_line (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_end_game_screen),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
    .text_buf(game_over_buf),
	.word_pixel(game_over_pixel),	
	.pixel_valid(game_over_pixel_valid)
);

// --------------- SCORE --------------------------


reg [5:0] score_buf [0:SCORE_SIZE-1];
wire score_pixel_valid;
wire [23:0]  score_pixel;

initial begin
    score_buf[0] = 28;
    score_buf[1] = 12;
    score_buf[2] = 24;
    score_buf[3] = 27;
    score_buf[4] = 14;
end

text_line #(
    .TEXT_SIZE(SCORE_SIZE),
    .TEXT_X0(SCORE_X0),
    .TEXT_Y0(SCORE_Y0)
) score_value_line (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_score),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
    .text_buf(score_buf),
	.word_pixel(score_pixel),	
	.pixel_valid(score_pixel_valid)
);

// --------------- SCORE VALUE --------------------------

reg [5:0] score_value_buf [0:SCORE_VALUE_SIZE-1];
wire score_value_pixel_valid;
wire [23:0]  score_value_pixel;


always @(posedge clk, negedge rst_n) begin 
    if(!rst_n) begin 
        score_value_buf[0] = 0;
        score_value_buf[1] = 0;
        score_value_buf[2] = 0;
        score_value_buf[3] = 0;
    end 
    else begin 
        
        if (score >= 9999) begin
            score_value_buf[0] <= 9;
            score_value_buf[1] <= 9;
            score_value_buf[2] <= 9;
            score_value_buf[3] <= 9;
        end 
        else begin 
            score_value_buf[0] <= (score / 1000) % 10;
            score_value_buf[1] <= (score / 100)  % 10;
            score_value_buf[2] <= (score / 10)   % 10;
            score_value_buf[3] <= 6'd0;
        end
    end
end 


text_line #(
    .TEXT_SIZE(SCORE_VALUE_SIZE),
    .TEXT_X0(SCORE_VALUE_X0),
    .TEXT_Y0(SCORE_VALUE_Y0)
) game_over_line (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_score),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
    .text_buf(score_value_buf),
	.word_pixel(score_value_pixel),	
	.pixel_valid(score_value_pixel_valid)
);

// ------------------- HIGH SCORE ------------------

reg [5:0] high_score_buf [0:HIGH_SCORE_SIZE-1];
wire high_score_pixel_valid;
wire [23:0] high_score_pixel;

initial begin
    high_score_buf[0] = 36; // H
    high_score_buf[1] = 18; // I
    high_score_buf[2] = 37; // -
    high_score_buf[3] = 28; // S
    high_score_buf[4] = 12; // C
    high_score_buf[5] = 24; // O
    high_score_buf[6] = 27; // R
    high_score_buf[7] = 14; // E
end


text_line #(
    .TEXT_SIZE(HIGH_SCORE_SIZE),
    .TEXT_X0(HIGH_SCORE_X0),
    .TEXT_Y0(HIGH_SCORE_Y0)
) high_score_line (
	.clk(clk),
	.rst_n(rst_n),
	.enable(enable_score),
	.lcd_xpos(lcd_xpos),
	.lcd_ypos(lcd_ypos),
    .text_buf(high_score_buf),
	.word_pixel(high_score_pixel),
	.pixel_valid(high_score_pixel_valid)
);

// ----------------- HIGH SCORE VALUE ---------------------

reg [5:0] high_score_value_buf [0:HIGH_SCORE_VALUE_SIZE-1];

wire high_score_value_pixel_valid;
wire [23:0] high_score_value_pixel;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        high_score_value_buf[0] <= 0;
        high_score_value_buf[1] <= 0;
        high_score_value_buf[2] <= 0;
        high_score_value_buf[3] <= 0;
    end
    else begin
        if (high_score >= 9999) begin
            high_score_value_buf[0] <= 9;
            high_score_value_buf[1] <= 9;
            high_score_value_buf[2] <= 9;
            high_score_value_buf[3] <= 9;
        end
        else begin
            high_score_value_buf[0] <= (high_score / 1000) % 10;
            high_score_value_buf[1] <= (high_score / 100)  % 10;
            high_score_value_buf[2] <= (high_score / 10)   % 10;
            high_score_value_buf[3] <=  6'd0;
        end
    end
end

text_line #(
    .TEXT_SIZE(HIGH_SCORE_VALUE_SIZE),
    .TEXT_X0(HIGH_SCORE_VALUE_X0),
    .TEXT_Y0(HIGH_SCORE_VALUE_Y0)
) high_score_value_line (
	.clk(clk),
	.rst_n(rst_n),
	.enable(enable_score),
	.lcd_xpos(lcd_xpos),
	.lcd_ypos(lcd_ypos),
    .text_buf(high_score_value_buf),
	.word_pixel(high_score_value_pixel),
	.pixel_valid(high_score_value_pixel_valid)
);


endmodule



