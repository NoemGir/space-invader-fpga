`timescale 1ns/1ns

module lcd_data_wrapper
#(
    parameter H_DISP = 800,
    parameter V_DISP = 480
)
(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [11:0] lcd_xpos,
    input  wire [11:0] lcd_ypos,
    input  wire [4:0]  buttons,

    input  wire [2:0]   game_state,
  //  input       [13:0]   high_score,

    output wire [2:0]   game_status,
    output wire [13:0]  score,

    output wire [23:0]  lcd_data
);

wire [13:0]  high_score;
reg [13:0]  high_score_reg;

wire [10:0] lcd_xpos_new;
wire [10:0] lcd_ypos_new;
wire [1:0]   move_gun;
wire         shoot;
wire enable_game = game_state > 3'b000;
wire freeze = game_state ==  3'b10 || game_state ==  3'b11;
wire show_game_start = game_state == 3'b000;
wire show_game_over = game_state == 3'b011;

assign move_gun = buttons[2] ? 2'b01 :
                  buttons[4] ? 2'b10 : 2'b00;

assign shoot = buttons[0];
reg [1:0] plus_score;


reg game_started; 
reg [13:0] computed_score;
wire game_over_finished = is_game_over && !show_game_over;
wire game_just_started = enable_game && !game_started;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        game_started <= 1'b0;
    else
        game_started <= rst_n;
end

reg is_game_over;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        is_game_over <= 1'b0;
    else
        is_game_over <= show_game_over;
end

assign score = computed_score;
assign high_score = high_score_reg; 

always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) 
        high_score_reg <= 14'd0;
    else if (game_over_finished) begin 
        if (score > high_score_reg)
            high_score_reg <= score;
    end
end 



always @(posedge clk or negedge rst_n) begin
    if(!rst_n) 
        computed_score <= 14'd0;
    else if (game_just_started || game_over_finished) 
        computed_score <= 14'd0;
    else if (plus_score != 2'b00) 
        computed_score <= score + (plus_score * 10);
end


lcd_data_mod lcd_data_inst (
    .clk      (clk),
    .rst_n    (rst_n),
    .lcd_xpos (lcd_xpos),
    .lcd_ypos (lcd_ypos),
    .lcd_data (lcd_data),
    .move_gun(move_gun),
    .shoot(shoot),
    .freeze(freeze),
    .enable_game(enable_game),
    .show_game_start(show_game_start),
    .show_game_over(show_game_over),
    .high_score(high_score),
    .score(score),
    .finished(game_status),
    .plus_score(plus_score)
);

endmodule
