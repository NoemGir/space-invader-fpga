import enemies_struct::*;


module enemies_top
#(
	parameter Y_MAX = 490,
	parameter X_MAX = 655,
    parameter FIG_X0 = 100, 
    parameter FIG_Y0 = 45 ,
    parameter ENEMY_WIDTH = 46,
    parameter ENEMY_HEIGHT = 42,

    parameter ANIM_FRAME = 9500000,
    parameter SPEED_REDUCTION = 8000,

    parameter STEP = 15,
    parameter ADVANCE_DIST = 15,

    parameter NB_ENEMY_Y = 10,
    parameter NB_ENEMY_X = 5,
    parameter ENEMIES_WIDTH = NB_ENEMY_X *ENEMY_WIDTH, 
    parameter ENEMIES_HEIGHT = NB_ENEMY_Y * ENEMY_HEIGHT
)
( 
	input  wire			clk,	
	input  wire			rst_n,	
	input  wire	[11:0]	lcd_xpos,
	input  wire	[11:0]	lcd_ypos,
    input  wire         enable,
    input  wire         freeze,
    input  wire	[11:0]	killed_enemy_x,
	input  wire	[11:0]	killed_enemy_y,
    input               valid_enemy_collision,

	output wire  [23:0]	enemy_pixel,
	output wire  	    pixel_valid,
    output reg   [2:0]  finished,

    output reg  [1:0] plus_score,

	output wire  	     explosion_pixel_valid,
	output wire  [23:0]  explosion_pixel
);

wire frame_rate = (lcd_xpos == 0) && (lcd_ypos == 0);

enemy_t enemies[NB_ENEMY_Y][NB_ENEMY_X];


reg  [11:0]	dead_enemy_x, dead_enemy_y;

wire killed_enemy = plus_score != 2'b00;

enemy_control #(
    .MAX_Y(Y_MAX),
    .MAX_X(X_MAX),
    .Y0(FIG_Y0),
    .X0(FIG_X0),
    .NB_ENEMY_Y(NB_ENEMY_Y),
    .NB_ENEMY_X(NB_ENEMY_X),
    .ENEMY_WIDTH(ENEMY_WIDTH),
    .ENEMY_HEIGHT(ENEMY_HEIGHT)
) u_ctrl (
  .clk(clk),
  .rst_n(rst_n),
  .enable(enable),
  .frame_rate(frame_rate),
  .freeze(freeze),
  .killed_enemy_x(killed_enemy_x),
  .killed_enemy_y(killed_enemy_y),
  .valid_enemy_collision(valid_enemy_collision),
  .enemies(enemies),
  .finished(finished),
  .plus_score(plus_score),
  .dead_enemy_x(dead_enemy_x),
  .dead_enemy_y(dead_enemy_y)
);

enemy_renderer #(
    .NB_ENEMY_Y(NB_ENEMY_Y),
    .NB_ENEMY_X(NB_ENEMY_X),
    .ENEMY_WIDTH(ENEMY_WIDTH),
    .ENEMY_HEIGHT(ENEMY_HEIGHT)
)u_rend (
  .lcd_xpos(lcd_xpos),
  .lcd_ypos(lcd_ypos),
  .enable(enable),
  .enemies(enemies),
  .enemy_pixel(enemy_pixel),
  .pixel_valid(pixel_valid)
);

explosion_pixel_mod explosion_pixel_inst (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(killed_enemy),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
	.fig_x(dead_enemy_x),	
	.fig_y(dead_enemy_y),
	.explosion_pixel(explosion_pixel),	
	.pixel_valid(explosion_pixel_valid)
);


endmodule