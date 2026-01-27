import enemies_struct::*;

module enemy_renderer #(
  parameter int NB_ENEMY_Y = 10,
  parameter int NB_ENEMY_X = 5,
  parameter int ENEMY_WIDTH    = 32,
  parameter int ENEMY_HEIGHT    = 32
)(
  input wire clk, 
  input wire rst_n,
  input  wire [11:0] lcd_xpos,
  input  wire [11:0] lcd_ypos,
  input  wire         enable,
  input  enemy_t enemies[NB_ENEMY_Y][NB_ENEMY_X],

  output wire [23:0] enemy_pixel,
  output wire        pixel_valid
);

`define CAT_WHITE   24'hFFFFFF
`define CAT_BLACK   24'h000000
`define CAT_PINK    24'hdbdbdb
`define CAT_GRAY    24'hFFD5C0
`define OTHER       24'h654321

`define C2_COLOR_1   21'h1F3F1F
`define C2_COLOR_2   21'h00000
`define C2_COLOR_3   21'h1F3313
`define C2_COLOR_4   21'h1F0C13
`define C2_COLOR_5   21'h1F261F
`define C2_COLOR_6   21'h132613
`define C2_COLOR_7   21'hA140A
`define C2_COLOR_8   21'h122613
`define C2_COLOR_9   21'h1F2816

`define C3_COLOR_1   21'h1F3F1F
`define C3_COLOR_2   21'h00000
`define C3_COLOR_3   21'h1F3C00
`define C3_COLOR_4   21'h1D2613
`define C3_COLOR_5   21'h1F3D19
`define C3_COLOR_6   21'h1F3E17

reg [23:0] lcd_data;
reg valid;

reg valid_C2;
reg [23:0] lcd_data_C2;


reg valid_C3;
reg [23:0] lcd_data_C3;

assign enemy_pixel = valid ? lcd_data : 
                    valid_C2 ? lcd_data_C2 : 
                    valid_C3 ? lcd_data_C3 : 24'hffffff;

assign pixel_valid = valid || valid_C2 || valid_C3;

reg hit;
reg signed [4:0] x_coord, y_coord;
reg [1:0] cat_id;


always_comb begin
    hit = 0;
    x_coord = 0;
    y_coord = 0;
    cat_id = 0;
    for (int r = 0; r < NB_ENEMY_Y; r++) begin
        for (int c = 0; c < NB_ENEMY_X; c++) begin
            if (!hit && enemies[r][c].alive) begin
                if (lcd_xpos >= enemies[r][c].x && lcd_xpos < enemies[r][c].x + ENEMY_WIDTH &&
                    lcd_ypos >= enemies[r][c].y && lcd_ypos < enemies[r][c].y + ENEMY_HEIGHT) begin
                    hit = 1'b1;
                    x_coord = (lcd_xpos - enemies[r][c].x) >> 1;
                    y_coord = (lcd_ypos - enemies[r][c].y) >> 1 ;
                    cat_id = enemies[r][c].id;
                end
            end
        end
    end
end

always_comb begin
        lcd_data <= 24'd0;
        valid <= 1'b0;
        if (hit && enable && cat_id == 2'b00) begin
            valid <= 1'b0;
            case (y_coord)
                1: case (x_coord)
                    7: begin lcd_data <= `CAT_GRAY; valid <= 1'b1; end
                    8: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                    10, 11, 12, 13: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                endcase
                2: case (x_coord)
                    9, 12, 13: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                    10, 11: begin lcd_data <= `CAT_PINK; valid <= 1'b1; end
                endcase
                3: case (x_coord)
                    5, 6, 7, 8, 13: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    9, 11, 12: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                    10: begin lcd_data <= `CAT_PINK; valid <= 1'b1; end
                endcase
                4: case (x_coord)
                    2, 3, 4, 9: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    5, 6: begin lcd_data <= `CAT_GRAY; valid <= 1'b1; end
                    7, 8, 11, 12, 13: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                    10: begin lcd_data <= `CAT_PINK; valid <= 1'b1; end
                endcase
                5: case (x_coord)
                    2, 13: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    3, 4, 5, 6: begin lcd_data <= `CAT_GRAY; valid <= 1'b1; end
                    7, 8, 9, 10, 11, 12: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                endcase
                6: case (x_coord)
                    3, 10, 13: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    4, 5, 6, 11: begin lcd_data <= `CAT_GRAY; valid <= 1'b1; end
                    7, 8, 9, 12: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                endcase
                7: case (x_coord)
                    4, 7, 8, 10, 13: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    5, 11: begin lcd_data <= `CAT_GRAY; valid <= 1'b1; end
                    6, 9, 12: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                endcase
                8: case (x_coord)
                    4, 10, 13: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    5, 6, 7, 8, 9, 12: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                    11: begin lcd_data <= `CAT_GRAY; valid <= 1'b1; end
                endcase
                9: case (x_coord)
                    4, 10: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    5, 6, 7, 8, 9, 11, 12, 13: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                endcase
                10: case (x_coord)
                    3,7, 8, 10, 13 : begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    4, 5: begin lcd_data <= `CAT_PINK; valid <= 1'b1; end
                    6, 9, 11, 12: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                endcase
                11: case (x_coord)
                    2, 10: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    3, 4, 5, 6: begin lcd_data <= `CAT_PINK; valid <= 1'b1; end
                    7, 8, 9, 11, 12, 13: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                endcase
                12: case (x_coord)
                    2, 3, 4, 9, 11, 12, 13: begin lcd_data <= `CAT_BLACK; valid <= 1'b1; end
                    5, 6: begin lcd_data <= `CAT_PINK; valid <= 1'b1; end
                    7, 8: begin lcd_data <= `CAT_WHITE; valid <= 1'b1; end
                endcase
            endcase
        end
end

always_comb begin
        lcd_data_C3 <= 24'd0;
        valid_C3 <= 1'b0;
        if (hit && enable && cat_id == 2'b10) begin
            valid_C3 <= 1'b0;
            case (y_coord)
               1: case (x_coord)
                  3: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  6: begin lcd_data_C3 <= `C3_COLOR_6; valid_C3 <= 1'b1; end
                endcase
               2: case (x_coord)
                  2, 5, 7, 8, 12: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  3, 4, 9, 10, 11: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  6: begin lcd_data_C3 <= `C3_COLOR_5; valid_C3 <= 1'b1; end
                endcase
               3: case (x_coord)
                  2, 8, 9, 10, 11, 13: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  3, 4, 5, 6, 7, 12: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                endcase
               4: case (x_coord)
                  2, 7, 8, 12, 13: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  3, 4, 6, 9, 10, 11: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  5: begin lcd_data_C3 <= `C3_COLOR_4; valid_C3 <= 1'b1; end
                endcase
               5: case (x_coord)
                  1, 3, 4, 6: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  2, 7, 8, 9, 10, 11, 12, 13: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  5: begin lcd_data_C3 <= `C3_COLOR_4; valid_C3 <= 1'b1; end
                endcase
               6: case (x_coord)
                  1, 3, 4, 6, 9, 10: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  2, 5, 7, 8, 11, 12, 13: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                endcase
               7: case (x_coord)
                  1, 6, 9, 13: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  2, 3, 4, 5, 7, 8, 10, 11, 12: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                endcase
               8: case (x_coord)
                  1, 2, 3, 4, 5, 6, 9, 10, 11, 12: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  7, 8, 13: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                endcase
               9: case (x_coord)
                  1, 4, 5, 7, 8, 10, 11, 12, 13: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  2, 3, 6, 9: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                endcase
               10: case (x_coord)
                  1, 5, 7, 8, 11, 12, 13: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  2, 3, 6, 9, 10: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  4: begin lcd_data_C3 <= `C3_COLOR_4; valid_C3 <= 1'b1; end
                endcase
               11: case (x_coord)
                  1, 7: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  2, 3, 5, 6, 8, 9, 10, 11: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  4: begin lcd_data_C3 <= `C3_COLOR_4; valid_C3 <= 1'b1; end
                endcase
               12: case (x_coord)
                  3, 7, 8, 9: begin lcd_data_C3 <= `C3_COLOR_2; valid_C3 <= 1'b1; end
                  4: begin lcd_data_C3 <= `C3_COLOR_5; valid_C3 <= 1'b1; end
                  5, 10, 11: begin lcd_data_C3 <= `C3_COLOR_3; valid_C3 <= 1'b1; end
                  6: begin lcd_data_C3 <= `C3_COLOR_6; valid_C3 <= 1'b1; end
                endcase
               13: case (x_coord)
                  4, 6: begin lcd_data_C3 <= `C3_COLOR_5; valid_C3 <= 1'b1; end
                endcase
            endcase
    end
end


always_comb begin
        lcd_data_C2 <=24'd0;
        valid_C2 <= 1'b0;
        if (hit && enable && cat_id == 2'b01) begin
            valid_C2 <= 1'b0;
            case (y_coord)
               1: case (x_coord)
                  4, 11: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  5, 8: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                  6, 7: begin lcd_data_C2 <= `C2_COLOR_7; valid_C2 <= 1'b1; end
                  9: begin lcd_data_C2 <= `C2_COLOR_9; valid_C2 <= 1'b1; end
                  10: begin lcd_data_C2 <= `C2_COLOR_8; valid_C2 <= 1'b1; end
                endcase
               2: case (x_coord)
                  5, 8, 10, 11, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  6, 7, 9: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                  12: begin lcd_data_C2 <= `C2_COLOR_8; valid_C2 <= 1'b1; end
                endcase
               3: case (x_coord)
                  4, 5, 9, 11, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  6, 7, 8: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                  10: begin lcd_data_C2 <= `C2_COLOR_9; valid_C2 <= 1'b1; end
                  12: begin lcd_data_C2 <= `C2_COLOR_8; valid_C2 <= 1'b1; end
                endcase
               4: case (x_coord)
                  3, 5, 10, 11, 12: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  4: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  6, 7, 8, 9: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                endcase
               5: case (x_coord)
                  2, 4, 8, 11, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  3: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  5, 6, 7, 9: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                  10, 12: begin lcd_data_C2 <= `C2_COLOR_8; valid_C2 <= 1'b1; end
                endcase
               6: case (x_coord)
                  2, 5, 11, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  3: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  4: begin lcd_data_C2 <= `C2_COLOR_4; valid_C2 <= 1'b1; end
                  6, 10: begin lcd_data_C2 <= `C2_COLOR_7; valid_C2 <= 1'b1; end
                  7, 8: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                  9: begin lcd_data_C2 <= `C2_COLOR_9; valid_C2 <= 1'b1; end
                  12: begin lcd_data_C2 <= `C2_COLOR_8; valid_C2 <= 1'b1; end
                endcase
               7: case (x_coord)
                  2, 6, 7, 10, 11, 12: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  3: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  4, 5: begin lcd_data_C2 <= `C2_COLOR_5; valid_C2 <= 1'b1; end
                  8: begin lcd_data_C2 <= `C2_COLOR_8; valid_C2 <= 1'b1; end
                  9: begin lcd_data_C2 <= `C2_COLOR_7; valid_C2 <= 1'b1; end
                endcase
               8: case (x_coord)
                  2, 8, 9, 11, 12, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  3, 10: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  4, 5, 7: begin lcd_data_C2 <= `C2_COLOR_5; valid_C2 <= 1'b1; end
                  6: begin lcd_data_C2 <= `C2_COLOR_4; valid_C2 <= 1'b1; end
                endcase
               9: case (x_coord)
                  2, 11, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  3, 10: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  4, 6, 7, 9: begin lcd_data_C2 <= `C2_COLOR_5; valid_C2 <= 1'b1; end
                  5, 8: begin lcd_data_C2 <= `C2_COLOR_4; valid_C2 <= 1'b1; end
                  12: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                endcase
               10: case (x_coord)
                  2, 11, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  3, 10: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  4, 5, 6, 7, 8: begin lcd_data_C2 <= `C2_COLOR_5; valid_C2 <= 1'b1; end
                  9: begin lcd_data_C2 <= `C2_COLOR_4; valid_C2 <= 1'b1; end
                  12: begin lcd_data_C2 <= `C2_COLOR_8; valid_C2 <= 1'b1; end
                endcase
               11: case (x_coord)
                  2, 11, 12: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  3, 10: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  4, 7: begin lcd_data_C2 <= `C2_COLOR_4; valid_C2 <= 1'b1; end
                  5, 6, 8, 9: begin lcd_data_C2 <= `C2_COLOR_5; valid_C2 <= 1'b1; end
                endcase
               12: case (x_coord)
                  3, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  4, 5, 6, 7, 8, 9: begin lcd_data_C2 <= `C2_COLOR_3; valid_C2 <= 1'b1; end
                  10, 11: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                  12: begin lcd_data_C2 <= `C2_COLOR_7; valid_C2 <= 1'b1; end
                endcase
               13: case (x_coord)
                  4, 5, 9, 13: begin lcd_data_C2 <= `C2_COLOR_2; valid_C2 <= 1'b1; end
                  6, 7, 8, 10: begin lcd_data_C2 <= `C2_COLOR_7; valid_C2 <= 1'b1; end
                  11: begin lcd_data_C2 <= `C2_COLOR_8; valid_C2 <= 1'b1; end
                  12: begin lcd_data_C2 <= `C2_COLOR_6; valid_C2 <= 1'b1; end
                endcase
            endcase
        end
end

endmodule