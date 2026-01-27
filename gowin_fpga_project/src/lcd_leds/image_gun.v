module gun_pixel_mod
#(
	parameter Y_MAX = 480,
    parameter FIG_X0 = 730, // horizontal position on screen
    parameter FIG_Y0 = 220 ,  // vertical position on screen
    parameter FIG_WIDTH = 87, 
    parameter FIG_HEIGHT = 40,
    parameter ANIM_FRAME = 80000
)  
( 
	input  wire			clk,	
	input  wire			rst_n,	
	input  wire	[11:0]	lcd_xpos,
	input  wire	[11:0]	lcd_ypos,
    input  wire         enable,
    input  wire         freeze,
    input  wire [1:0]   mov_y, // = 1 ( right ) = 2 (left ) = 0, 3 don't move

	output wire  [23:0]	gun_pixel,	
	output wire  	    pixel_valid,
    output wire  [11:0] pos_y
);

`define RGB565(R,G,B) {3'b0, R, 2'b0, G, 3'b0, B}

`define GUN_GRAY      `RGB565(5'd28, 6'd46, 5'd27)
`define GUN_GRAY_HARD `RGB565(5'd24, 6'd39, 5'd24)
`define GUN_BLACK     `RGB565(5'd8, 6'd14, 5'd7)
`define GUN_BROWN     `RGB565(5'd26, 6'd32, 5'd10)
`define GUN_BROWN_LIGHT `RGB565(5'd29, 6'd38, 5'd10)
`define OTHER         `RGB565(5'd23, 6'd62, 5'd26)


reg [11:0] lcd_x_r, lcd_y_r;
reg signed [11:0] dx_r, dy_r;
reg [5:0] x_coord;
reg [4:0] y_coord;
reg inside_sprite;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_x_r <= 0;
        lcd_y_r <= 0;
        dx_r <= 0;
        dy_r <= 0;
        x_coord <= 6'd0;
        y_coord <= 5'd0;
        inside_sprite <= 1'b0;
    end else begin
        lcd_x_r <= lcd_xpos;
        lcd_y_r <= lcd_ypos;

        dx_r <= $signed({1'b0, lcd_xpos}) - $signed({1'b0, position_x});
        dy_r <= $signed({1'b0, lcd_ypos}) - $signed({1'b0, position_y});

        x_coord <= (dx_r >= 0) ? (dx_r >>> 1) : 6'd0;;
        y_coord <= (dy_r >= 0) ? (dy_r >>> 1) : 5'd0;;

        inside_sprite <= enable &&
                           (dx_r >= 0 && dx_r < FIG_WIDTH) &&
                           (dy_r >= 0 && dy_r < FIG_HEIGHT) &&
                           (x_coord >= 1 && x_coord <= 28) &&
                           (y_coord >= 1 && y_coord <= 16);
    end
end

assign pos_y = position_y;

reg [11:0] position_x;
reg [11:0] position_y;

reg [23:0] lcd_data;
reg valid;

assign gun_pixel = lcd_data;
assign pixel_valid = valid;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid <= 1'b0;
        lcd_data <= 24'd0;
    end else begin
        lcd_data  <= 24'd0;
        valid <=   1'b0;
        if (inside_sprite && enable) begin
            valid <= 1'b0; 
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
        end else if (!inside_sprite) valid <= 1'b0;
    end
end

wire frame_tick = (lcd_xpos == 0 && lcd_ypos == 0);
reg [16:0] counter;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 16'b0;
        position_y <= FIG_Y0;
        position_x <= FIG_X0;
    end
    else if (!enable || freeze) 
        counter <= 16'b0;
    else if (frame_tick) begin
        counter <= counter + 1'b1;
        if (counter == ANIM_FRAME) begin
            case (mov_y)
                2'b01 : begin  if (position_y + 1 + FIG_HEIGHT <= Y_MAX) position_y <= position_y + 1'b1; end
                2'b10 : begin  if (position_y - 1'b1 > 0 ) position_y <= position_y - 1'b1 ; end
            endcase 
           counter <= 16'b0;
        end
    end
end

endmodule