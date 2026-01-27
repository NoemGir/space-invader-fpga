`timescale 1ns/1ns

module lcd_data_mod
#(
    parameter ENEMY_0_Y = 0,  // Y
	parameter ENEMY_1_Y = 60,  // Y
	parameter ENEMY_2_Y = 120,  // Y
	parameter ENEMY_3_Y = 180,  // Y
	parameter ENEMY_4_Y = 240  // Y
)
( 
	input  wire	 		clk,	
	input  wire			rst_n,	
	input  wire	[11:0]	lcd_xpos,	//lcd horizontal coordinate
	input  wire	[11:0]	lcd_ypos,	//lcd vertical coordinate
	input wire  [1:0]   move_gun,
	input wire          shoot,
    input wire          freeze,
    input wire          enable_game,
    input wire          show_game_start,
    input wire          show_game_over,
    input       [13:0]  high_score,
    input       [13:0]  score,


    output [1:0] plus_score,
	output wire  [23:0]	lcd_data,
    output reg   [2:0]  finished
);

`define RGB565(R,G,B) {3'b0, R, 2'b0, G, 3'b0, B}
`define PINK    `RGB565(5'd31, 6'd20, 5'd25)
`define BACKGROUND `RGB565(5'd3, 6'd3, 5'd7)

wire        gun_pixel_valid;
wire [23:0] gun_pixel;

wire        word_pixel_valid;
wire [23:0] word_pixel;

wire        wall_pixel_valid0;
wire [23:0] wall_pixel0;

wire        wall_pixel_valid1;
wire [23:0] wall_pixel1;

wire        wall_pixel_valid2;
wire [23:0] wall_pixel2;

wire        enemy_pixel_valid;
wire [23:0] enemy_pixel;

wire        bullet_pixel_valid;
wire [23:0] bullet_pixel;

wire        explosion_pixel_valid;
wire [23:0] explosion_pixel;


assign lcd_data = word_pixel_valid ? word_pixel :
                  explosion_pixel_valid ? explosion_pixel : 
                  gun_pixel_valid ? gun_pixel :
                  bullet_pixel_valid ? bullet_pixel : 
                  wall_pixel_valid0 ? wall_pixel0 : 
                  wall_pixel_valid1 ? wall_pixel1 : 
                  wall_pixel_valid2 ? wall_pixel2 : 
                  enemy_pixel_valid ? enemy_pixel : `BACKGROUND;

wire  collision_bullet_enemy = enemy_pixel_valid && bullet_pixel_valid; 
wire collision_bullet_wall = (wall_pixel_valid0 || wall_pixel_valid1 || wall_pixel_valid2)  && bullet_pixel_valid; 
wire collision = collision_bullet_wall || valid_enemy_collision;

reg [11:0] killed_enemy_x;
reg [11:0] killed_enemy_y;
reg [2:0] collision_counter = 3'd0; 

reg valid_enemy_collision; 

always_ff @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin
        killed_enemy_x <= 12'd0;
        killed_enemy_y <= 12'd0;
        collision_counter <= 3'd0;
        valid_enemy_collision <= 1'b0;
    end  else begin 
        valid_enemy_collision <= 1'b0;
        if(collision_bullet_enemy) begin 
            if(collision_counter == 3'd0) begin 
                killed_enemy_x <= lcd_xpos;
                killed_enemy_y <= lcd_ypos;
            end
            if(collision_counter == 3'd1) 
                valid_enemy_collision <= 1'b1;
    
            collision_counter <= collision_counter + 1'b1;
       end else begin 
            collision_counter <= 3'd0;
            killed_enemy_x <= 12'd0;
            killed_enemy_y <= 12'd0;
        end
    end
end


// share position of the gun with the bullet 
wire [11:0] pos_y;

image_texts word_pixel_inst (
	.clk(clk),	
	.rst_n(rst_n),
    .show_game_over(show_game_over),
    .show_game_start(show_game_start),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
	.text_pixel(word_pixel),
	.score(score),	
	.high_score(high_score),			
	.pixel_valid(word_pixel_valid)
);

gun_pixel_mod gun_pixel_inst (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_game),
	.freeze(freeze),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
    .mov_y(move_gun),
	.gun_pixel(gun_pixel),	
	.pixel_valid(gun_pixel_valid),
	.pos_y(pos_y)
    
);

wall_pixel_mod #(.FIG_Y0(50) )wall_pixel_inst_0 (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_game),
	.freeze(freeze),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
	.wall_pixel(wall_pixel0),	
	.pixel_valid(wall_pixel_valid0)  
);

wall_pixel_mod #(.FIG_Y0(200) ) wall_pixel_inst_1 (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_game),
	.freeze(freeze),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
	.wall_pixel(wall_pixel1),	
	.pixel_valid(wall_pixel_valid1)  
);

wall_pixel_mod #(.FIG_Y0(350) )wall_pixel_inst_2 (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_game),
	.freeze(freeze),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),	
	.wall_pixel(wall_pixel2),	
	.pixel_valid(wall_pixel_valid2)  
);

bullet_pixel_mod bullet_inst (
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_game),
	.freeze(freeze),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),
	.y_pos(pos_y),		
    .collision(collision),
	.shoot(shoot),
	.bullet_pixel(bullet_pixel),	
	.pixel_valid(bullet_pixel_valid)
);

enemies_top enemy_pixel_inst_0
(
	.clk(clk),	
	.rst_n(rst_n),
	.enable(enable_game),
	.freeze(freeze),
	.lcd_xpos(lcd_xpos),	
	.lcd_ypos(lcd_ypos),
	.enemy_pixel(enemy_pixel),	
	.pixel_valid(enemy_pixel_valid),
	.killed_enemy_x(killed_enemy_x),
	.killed_enemy_y(killed_enemy_y),
    .valid_enemy_collision(valid_enemy_collision),
    .finished(finished),
    .plus_score(plus_score),
    .explosion_pixel_valid(explosion_pixel_valid),
    .explosion_pixel(explosion_pixel)
);
endmodule