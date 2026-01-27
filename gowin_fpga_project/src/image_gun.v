module gun_pixel_mod
#(
	parameter Y_MAX = 490,
	parameter X_MAX = 200,
    parameter FIG_X0 = 730, //168,  // horizontal position on screen
    parameter FIG_Y0 = 220 , //52,  // vertical position on screen
    parameter FIG_WIDTH = 87,  // horizontal position on screen
    parameter FIG_HEIGHT = 55, // vertical position on screen
    parameter ANIM_FRAME = 100000 // vertical position on screen
)  
( 
	input  wire			clk,	
	input  wire			rst_n,	
	input  wire	[10:0]	lcd_xpos,
	input  wire	[10:0]	lcd_ypos,
    input  wire [1:0]   mov_y, // = 1 ( right ) = 2 (left ) = 0, 3 don't move

	output wire  [23:0]	gun_pixel,	//lcd data -> color of a single enemy_pixel RGB 8x8x8
	output wire  	    pixel_valid
);

`define RGB565(R,G,B) {3'b0, R, 2'b0, G, 3'b0, B}

`define GUN_GRAY      `RGB565(5'd28, 6'd46, 5'd27)
`define GUN_GRAY_HARD `RGB565(5'd24, 6'd39, 5'd24)
`define GUN_BLACK     `RGB565(5'd8, 6'd14, 5'd7)
`define GUN_BROWN     `RGB565(5'd26, 6'd32, 5'd10)
`define GUN_BROWN_LIGHT `RGB565(5'd29, 6'd38, 5'd10)
`define PINK    `RGB565(5'd31, 6'd42, 5'd30)
`define OTHER    `RGB565(5'd0, 6'd63, 5'd0)

wire [5:0] x_coord;
wire [4:0] y_coord;

reg [10:0] position_x;
reg [10:0] position_y;

initial position_x =  FIG_X0;
initial position_y =  FIG_Y0;

assign x_coord =  ((lcd_xpos - position_x)) / 2;// scaling up
assign y_coord = ((lcd_ypos - position_y)) / 2; // scaling up

reg [23:0] lcd_data;
reg valid;

wire [1:0] mov_x = 2'b00;
reg [25:0] counter;

assign gun_pixel = lcd_data;
assign pixel_valid = valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid <= 1'b0;
        lcd_data <= `PINK;
    end else begin
        lcd_data    <= `OTHER;
        valid <= 1'b0;
        if (lcd_xpos >= position_x && lcd_xpos < position_x + FIG_WIDTH && // evaluate when coordonnate are in 
            lcd_ypos >= position_y && lcd_ypos < position_y + FIG_HEIGHT)
        begin
           // valid <= 1'b1; verify figure space
            case (x_coord)
            1: case (y_coord)
                    3, 4, 5, 6, 7, 8 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
               endcase
            2: case (y_coord)
                   2, 3, 6, 8 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                   4, 5, 7  :   begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
               endcase
            3, 4, 5, 6, 7, 8, 9, 10, 11, 12 : case (y_coord)
                   3, 6, 8 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                   4, 5, 7  :   begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
             endcase
            13: case (y_coord)
                   2, 3, 4, 5, 6, 7, 8, 9, 10 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
               endcase
            14: case (y_coord)
                   2, 10 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 4, 5, 6, 7, 8, 9 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
               endcase
            15: case (y_coord)
                   2, 4, 5, 6, 7, 8, 10 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 9 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
               endcase
            16: case (y_coord)
                   2, 4, 6, 8,  10, 11 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 9 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
                   5, 7 : begin lcd_data <= `GUN_GRAY_HARD; valid <= 1'b1; end
               endcase
            17: case (y_coord)
                   2, 4, 5, 6, 7, 8, 10 , 11, 12 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 9 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
               endcase
            18, 20: case (y_coord)
                   2, 4, 6, 8, 10, 13 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 9, 5, 7 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
               endcase
            19: case (y_coord)
                   2, 4, 6, 8, 10, 11, 13 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 9, 5, 7 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
               endcase
            21: case (y_coord)
                   2, 4, 6, 8, 10,  11, 12 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 9, 5, 7 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
               endcase
            22: case (y_coord)
                   2, 4, 5, 6, 7, 8, 10, 11, 12 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 9 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
               endcase
            23: case (y_coord)
                   2, 9, 13, 14, 15  : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                    3, 4, 5, 6, 7, 8 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
                   10: begin lcd_data <= `GUN_BROWN_LIGHT; valid <= 1'b1; end
                   11, 12: begin lcd_data <= `GUN_BROWN   ; valid <= 1'b1; end
               endcase
            24: case (y_coord)
                   2,3, 4, 9, 15, 16 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                     5, 6, 7, 8 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
                   10: begin lcd_data <= `GUN_BROWN_LIGHT; valid <= 1'b1; end
                   11, 12, 13, 14: begin lcd_data <= `GUN_BROWN   ; valid <= 1'b1; end
               endcase
            25: case (y_coord)
                   1, 2,  4, 5,  8, 16 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                      6, 7 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
                   9: begin lcd_data <= `GUN_BROWN_LIGHT; valid <= 1'b1; end
                   10, 11, 12, 13, 14, 15: begin lcd_data <= `GUN_BROWN   ; valid <= 1'b1; end
               endcase
            26: case (y_coord)
                   2,  5, 6, 7,  8, 1, 16 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                      6, 7 : begin lcd_data <= `GUN_GRAY; valid <= 1'b1; end
                   9: begin lcd_data <= `GUN_BROWN_LIGHT; valid <= 1'b1; end
                   10, 11, 12, 13, 14, 15: begin lcd_data <= `GUN_BROWN   ; valid <= 1'b1; end
               endcase
            27: case (y_coord)
                    8 , 1, 9, 10, 11, 15, 16 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
                  12, 13, 14: begin lcd_data <= `GUN_BROWN   ; valid <= 1'b1; end
               endcase
            28: case (y_coord)
                    11, 12, 13, 14, 15 : begin lcd_data <= `GUN_BLACK; valid <= 1'b1; end
               endcase
           endcase
        end
    end
end

wire frame_tick = (lcd_xpos == 0 && lcd_ypos == 0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        position_x <= FIG_X0;
        position_y <= FIG_Y0;
    end else if (frame_tick) begin
        counter <= counter + 1;
        if (counter == ANIM_FRAME) begin
            case (mov_y)
                2'b01 : begin  if (position_y + 1 + FIG_HEIGHT <= Y_MAX) position_y <= position_y + 1'b1; end
                2'b10 : begin  if (position_y - 1'b1 >= 0 ) position_y <= position_y - 1'b1 ; end
            endcase 
            case (mov_x)
                2'b01 : begin  if (position_x + 1 + FIG_WIDTH <= X_MAX) position_x <= position_x + 1'b1; end
                2'b10 : begin  if (position_x -1'b1 >= 0 ) position_x <= position_x -1'b1 ; end
            endcase 
           counter <= 0;
        end
    end
end

endmodule