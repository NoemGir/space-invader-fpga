// animation de l'explosion du chat 

module explosion_pixel_mod
#(
    parameter FIG_WIDTH = 32, 
    parameter FIG_HEIGHT = 32,
    parameter FRAME_TIME = 1900000,
    parameter NB_FRAME = 6
)  
( 
    input  wire         clk,    
    input  wire         rst_n,  
    input  wire [11:0]  lcd_xpos,
    input  wire [11:0]  lcd_ypos,
    input       [11:0]  fig_x,
    input       [11:0]  fig_y,
    input              enable,

    output wire [23:0]  explosion_pixel,   // RGB pixel color
    output wire         pixel_valid
);

`define RGB565(R,G,B) {3'b0, R, 2'b0, G, 3'b0, B}
`define GREEN_BAD          `RGB565(5'd0, 6'd61, 5'd0)

`define F1_COLOR_1   21'h1F3F1F
`define F1_COLOR_2   21'h1F3C03
`define F1_COLOR_3   21'h1D1A05
`define F1_COLOR_4   21'h1F3F1C
`define F1_COLOR_5   21'h1E2C12
`define F1_COLOR_6   21'h1E2B04
`define F1_COLOR_7   21'h1F3703
`define F1_COLOR_8   21'h1F3F18
`define F1_COLOR_9   21'h1E1F05
`define F1_COLOR_10   21'h1E2B04
`define F1_COLOR_11   21'h1D1C05
`define F1_COLOR_12   21'h1F3F1B
`define F1_COLOR_13   21'h1F3E0F
`define F1_COLOR_14   21'h1E2D13


`define F2_COLOR_1   21'h1F3F1F
`define F2_COLOR_2   21'h180800
`define F2_COLOR_3   21'h1C1B07
`define F2_COLOR_4   21'h1F3F1D
`define F2_COLOR_5   21'h1F3C05
`define F2_COLOR_6   21'h1C1E07
`define F2_COLOR_7   21'h1F3905
`define F2_COLOR_8   21'h1F3C07
`define F2_COLOR_9   21'h1A1103
`define F2_COLOR_10   21'h180800

reg [11:0] lcd_x_r, lcd_y_r;
reg signed [11:0] dx_r, dy_r, fig_x_r, fig_y_r;
reg [5:0] x_coord;
reg [4:0] y_coord;
reg inside_sprite;



always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_x_r <= 0;
        lcd_y_r <= 0;
        dx_r <= 0;
        dy_r <= 0;
        x_coord <= 0;
        y_coord <= 0;
        inside_sprite <= 1'b0;
    end else begin
        lcd_x_r <= lcd_xpos;
        lcd_y_r <= lcd_ypos;

        x_coord <= (dx_r >= 0) ? (dx_r >>> 1) : 6'd0;
        y_coord <= (dy_r >= 0) ? (dy_r >>> 1) : 5'd0;

        inside_sprite <=
                           (dx_r >= 0 && dx_r < FIG_WIDTH) &&
                           (dy_r >= 0 && dy_r < FIG_HEIGHT) &&
                           (x_coord >= 1 && x_coord <= 13) &&
                           (y_coord >= 1 && y_coord <= 13);

         dx_r <= $signed({1'b0, lcd_xpos}) - $signed({1'b0, fig_x_r});
         dy_r <= $signed({1'b0, lcd_ypos}) - $signed({1'b0, fig_y_r});
    end
end

assign explosion_pixel = enable_frame1 ? lcd_data_F1 :
                         enable_frame2 ? lcd_data_F2 :
                         enable_frame3 ? lcd_data_F3 :
                         enable_frame4 ? lcd_data_F4 :
                         enable_frame5 ? lcd_data_F5 :
                         enable_frame6 ? lcd_data_F6 : 24'd0;


assign pixel_valid = enable_frame1 ? valid_F1 :
                     enable_frame2 ? valid_F2 :
                     enable_frame3 ? valid_F3 :
                     enable_frame4 ? valid_F4 :
                     enable_frame5 ? valid_F5 :
                     enable_frame6 ? valid_F6 : 1'b0;


reg [24:0] counter;
reg [2:0] frame_counter;

wire enable_frame1 = frame_counter == 3'd0;
wire enable_frame2 = frame_counter == 3'd1;
wire enable_frame3 = frame_counter == 3'd2;
wire enable_frame4 = frame_counter == 3'd3;
wire enable_frame5 = frame_counter == 3'd4;
wire enable_frame6 = frame_counter == 3'd5;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 25'd0;
        fig_x_r <= 0;
        fig_y_r <= 0;
        frame_counter <= 3'd0;
    end else begin
        if (enable) begin  
            counter <= 25'd0;
            fig_x_r <= fig_x;
            fig_y_r <= fig_y;
            frame_counter <= 3'd0;
        end
        else if (counter <= FRAME_TIME) begin
            counter <= counter + 1'b1;
        end
        else begin 
            if (frame_counter < NB_FRAME) begin 
                counter <= 25'd0;
                frame_counter <= frame_counter + 1'b1;
            end
        end
    end
end

reg valid_F1;
reg [23:0] lcd_data_F1;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_data_F1 <= 24'd0;
        valid_F1 <= 1'b0;
    end else begin
        lcd_data_F1 <= 24'd0;
        valid_F1 <= 1'b0;
        if (inside_sprite && enable_frame1) begin
            valid_F1 <= 1'b0;
            case (y_coord)
                2: case (x_coord)
                    4, 6, 7: begin lcd_data_F1 <= `F1_COLOR_5; valid_F1 <= 1'b1; end
                endcase
                3: case (x_coord)
                    3, 7, 9: begin lcd_data_F1 <= `F1_COLOR_2; valid_F1 <= 1'b1; end
                    4, 5, 8: begin lcd_data_F1 <= `F1_COLOR_3; valid_F1 <= 1'b1; end
                    6: begin lcd_data_F1 <= `F1_COLOR_7; valid_F1 <= 1'b1; end
                endcase
                4: case (x_coord)
                    3, 8: begin lcd_data_F1 <= `F1_COLOR_3; valid_F1 <= 1'b1; end
                    4, 7, 10: begin lcd_data_F1 <= `F1_COLOR_2; valid_F1 <= 1'b1; end
                    5: begin lcd_data_F1 <= `F1_COLOR_4; valid_F1 <= 1'b1; end
                    6: begin lcd_data_F1 <= `F1_COLOR_8; valid_F1 <= 1'b1; end
                    9: begin lcd_data_F1 <= `F1_COLOR_11; valid_F1 <= 1'b1; end
                endcase
                5: case (x_coord)
                    3, 4, 7, 8, 9: begin lcd_data_F1 <= `F1_COLOR_2; valid_F1 <= 1'b1; end
                    5, 6, 10: begin lcd_data_F1 <= `F1_COLOR_4; valid_F1 <= 1'b1; end
                    11: begin lcd_data_F1 <= `F1_COLOR_3; valid_F1 <= 1'b1; end
                endcase
                6: case (x_coord)
                    3, 4: begin lcd_data_F1 <= `F1_COLOR_3; valid_F1 <= 1'b1; end
                    5, 7, 8, 10, 11: begin lcd_data_F1 <= `F1_COLOR_2; valid_F1 <= 1'b1; end
                    6: begin lcd_data_F1 <= `F1_COLOR_8; valid_F1 <= 1'b1; end
                    9: begin lcd_data_F1 <= `F1_COLOR_4; valid_F1 <= 1'b1; end
                endcase
                7: case (x_coord)
                    3: begin lcd_data_F1 <= `F1_COLOR_4; valid_F1 <= 1'b1; end
                    4, 6, 9: begin lcd_data_F1 <= `F1_COLOR_2; valid_F1 <= 1'b1; end
                    5: begin lcd_data_F1 <= `F1_COLOR_6; valid_F1 <= 1'b1; end
                    7: begin lcd_data_F1 <= `F1_COLOR_3; valid_F1 <= 1'b1; end
                    8: begin lcd_data_F1 <= `F1_COLOR_10; valid_F1 <= 1'b1; end
                    10: begin lcd_data_F1 <= `F1_COLOR_13; valid_F1 <= 1'b1; end
                    11: begin lcd_data_F1 <= `F1_COLOR_14; valid_F1 <= 1'b1; end
                endcase
                8: case (x_coord)
                    3, 5, 8: begin lcd_data_F1 <= `F1_COLOR_2; valid_F1 <= 1'b1; end
                    4, 7: begin lcd_data_F1 <= `F1_COLOR_4; valid_F1 <= 1'b1; end
                    6: begin lcd_data_F1 <= `F1_COLOR_9; valid_F1 <= 1'b1; end
                    9, 10, 11: begin lcd_data_F1 <= `F1_COLOR_3; valid_F1 <= 1'b1; end
                endcase
                9: case (x_coord)
                    3, 8, 9, 10: begin lcd_data_F1 <= `F1_COLOR_3; valid_F1 <= 1'b1; end
                    4, 7: begin lcd_data_F1 <= `F1_COLOR_2; valid_F1 <= 1'b1; end
                    5: begin lcd_data_F1 <= `F1_COLOR_4; valid_F1 <= 1'b1; end
                    6: begin lcd_data_F1 <= `F1_COLOR_9; valid_F1 <= 1'b1; end
                endcase
                10: case (x_coord)
                    4, 5, 6, 7: begin lcd_data_F1 <= `F1_COLOR_3; valid_F1 <= 1'b1; end
                    9: begin lcd_data_F1 <= `F1_COLOR_12; valid_F1 <= 1'b1; end
                endcase
            endcase
        end
    end
end

reg valid_F2;
reg [23:0] lcd_data_F2;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_data_F2 <= 24'd0;
        valid_F2 <= 1'b0;
    end else begin
        lcd_data_F2 <= 24'd0;
        valid_F2 <= 1'b0;
        if (inside_sprite && enable_frame2) begin
            valid_F2 <= 1'b0;
            case (y_coord)
               1: case (x_coord)
                endcase
               2: case (x_coord)
                  2, 5, 6, 9, 10: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                  3, 4, 7, 8: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  11: begin lcd_data_F2 <= `F2_COLOR_9; valid_F2 <= 1'b1; end
                endcase
               3: case (x_coord)
                  2, 4, 6, 8, 10: begin lcd_data_F2 <= `F2_COLOR_4; valid_F2 <= 1'b1; end
                  3, 5, 11: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  7: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                  9: begin lcd_data_F2 <= `F2_COLOR_6; valid_F2 <= 1'b1; end
                endcase
               4: case (x_coord)
                  2, 3, 10: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  4, 5, 6, 8, 11: begin lcd_data_F2 <= `F2_COLOR_4; valid_F2 <= 1'b1; end
                  7: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                  9: begin lcd_data_F2 <= `F2_COLOR_7; valid_F2 <= 1'b1; end
                endcase
               5: case (x_coord)
                  1: begin lcd_data_F2 <= `F2_COLOR_2; valid_F2 <= 1'b1; end
                  2, 7, 8: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                  3, 10, 11: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  4, 5, 6: begin lcd_data_F2 <= `F2_COLOR_4; valid_F2 <= 1'b1; end
                  9: begin lcd_data_F2 <= `F2_COLOR_8; valid_F2 <= 1'b1; end
                endcase
               6: case (x_coord)
                  1: begin lcd_data_F2 <= `F2_COLOR_2; valid_F2 <= 1'b1; end
                  2, 3, 7: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  4, 5, 6, 8, 9, 10: begin lcd_data_F2 <= `F2_COLOR_4; valid_F2 <= 1'b1; end
                  11: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                endcase
               7: case (x_coord)
                  2, 3, 6, 10, 11: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  4, 5, 9: begin lcd_data_F2 <= `F2_COLOR_4; valid_F2 <= 1'b1; end
                  7, 8: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                endcase
               8: case (x_coord)
                  2, 5, 9, 10: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  3, 6, 11: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                  4, 7, 8: begin lcd_data_F2 <= `F2_COLOR_4; valid_F2 <= 1'b1; end
                endcase
               9: case (x_coord)
                  2, 5, 6: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  3, 7, 8: begin lcd_data_F2 <= `F2_COLOR_4; valid_F2 <= 1'b1; end
                  4, 9, 10: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                  11: begin lcd_data_F2 <= `F2_COLOR_10; valid_F2 <= 1'b1; end
                endcase
               10: case (x_coord)
                  2, 4, 6, 10: begin lcd_data_F2 <= `F2_COLOR_5; valid_F2 <= 1'b1; end
                  3: begin lcd_data_F2 <= `F2_COLOR_4; valid_F2 <= 1'b1; end
                  5, 7, 8, 9, 11: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                endcase
               11: case (x_coord)
                  2, 5, 6, 10: begin lcd_data_F2 <= `F2_COLOR_2; valid_F2 <= 1'b1; end
                  3, 9: begin lcd_data_F2 <= `F2_COLOR_3; valid_F2 <= 1'b1; end
                endcase
            endcase
        end
    end
end

`define F3_COLOR_1   21'h1F3F1F
`define F3_COLOR_2   21'h1F3F1F
`define F3_COLOR_3   21'h180800
`define F3_COLOR_4   21'h1C1B07
`define F3_COLOR_5   21'h1F3205
`define F3_COLOR_6   21'h1F3C05
`define F3_COLOR_7   21'h1A1203
`define F3_COLOR_8   21'h1C2310
`define F3_COLOR_9   21'h1D2B06
`define F3_COLOR_10   21'h1F3F1D
`define F3_COLOR_11   21'h1A1203
`define F3_COLOR_12   21'h1C1B06
`define F3_COLOR_13   21'h1F3B05
`define F3_COLOR_14   21'h1C240F
`define F3_COLOR_15   21'h1D2205
`define F3_COLOR_16   21'h1C1B07
`define F3_COLOR_17   21'h1F3206
`define F3_COLOR_18   21'h1F3206
`define F3_COLOR_19   21'h1D2706

reg valid_F3;
reg [23:0] lcd_data_F3;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_data_F3 <= 24'd0;
        valid_F3 <= 1'b0;
    end else begin
        lcd_data_F3 <= 24'd0;
        valid_F3 <= 1'b0;
        if (inside_sprite && enable_frame3) begin
            valid_F3 <= 1'b0;
            case (y_coord)
               1: case (x_coord)
                  3: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  7: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                endcase
               2: case (x_coord)
                  1: begin lcd_data_F3 <= `F3_COLOR_2; valid_F3 <= 1'b1; end
                  2, 3: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                  4: begin lcd_data_F3 <= `F3_COLOR_12; valid_F3 <= 1'b1; end
                  5, 8, 10, 11: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  6, 9: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                  7: begin lcd_data_F3 <= `F3_COLOR_16; valid_F3 <= 1'b1; end
                endcase
               3: case (x_coord)
                  1, 12: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                  2, 7, 10: begin lcd_data_F3 <= `F3_COLOR_6; valid_F3 <= 1'b1; end
                  3, 4, 9, 11: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                  5: begin lcd_data_F3 <= `F3_COLOR_7; valid_F3 <= 1'b1; end
                  6: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  8: begin lcd_data_F3 <= `F3_COLOR_16; valid_F3 <= 1'b1; end
                endcase
               4: case (x_coord)
                  2: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  3, 4, 5, 8, 11: begin lcd_data_F3 <= `F3_COLOR_6; valid_F3 <= 1'b1; end
                  6: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                  7: begin lcd_data_F3 <= `F3_COLOR_10; valid_F3 <= 1'b1; end
                  9: begin lcd_data_F3 <= `F3_COLOR_7; valid_F3 <= 1'b1; end
                  10, 12: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                endcase
               5: case (x_coord)
                  2: begin lcd_data_F3 <= `F3_COLOR_7; valid_F3 <= 1'b1; end
                  3, 4, 5, 7, 9, 10: begin lcd_data_F3 <= `F3_COLOR_6; valid_F3 <= 1'b1; end
                  6: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  8: begin lcd_data_F3 <= `F3_COLOR_18; valid_F3 <= 1'b1; end
                  11: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                  12: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                endcase
               6: case (x_coord)
                  1, 12: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                  2: begin lcd_data_F3 <= `F3_COLOR_7; valid_F3 <= 1'b1; end
                  3, 5: begin lcd_data_F3 <= `F3_COLOR_6; valid_F3 <= 1'b1; end
                  4, 9, 10: begin lcd_data_F3 <= `F3_COLOR_10; valid_F3 <= 1'b1; end
                  6, 7, 8, 11: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                endcase
               7: case (x_coord)
                  1, 7: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  2, 11: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                  3: begin lcd_data_F3 <= `F3_COLOR_9; valid_F3 <= 1'b1; end
                  4, 9: begin lcd_data_F3 <= `F3_COLOR_6; valid_F3 <= 1'b1; end
                  5: begin lcd_data_F3 <= `F3_COLOR_7; valid_F3 <= 1'b1; end
                  6: begin lcd_data_F3 <= `F3_COLOR_15; valid_F3 <= 1'b1; end
                  8: begin lcd_data_F3 <= `F3_COLOR_19; valid_F3 <= 1'b1; end
                  10: begin lcd_data_F3 <= `F3_COLOR_10; valid_F3 <= 1'b1; end
                  12: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                endcase
               8: case (x_coord)
                  1, 7, 12: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                  2, 9: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                  3, 11: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  4, 6: begin lcd_data_F3 <= `F3_COLOR_7; valid_F3 <= 1'b1; end
                  5: begin lcd_data_F3 <= `F3_COLOR_6; valid_F3 <= 1'b1; end
                  8: begin lcd_data_F3 <= `F3_COLOR_18; valid_F3 <= 1'b1; end
                  10: begin lcd_data_F3 <= `F3_COLOR_10; valid_F3 <= 1'b1; end
                endcase
               9: case (x_coord)
                  2, 4, 10: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                  3, 11: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  5, 7: begin lcd_data_F3 <= `F3_COLOR_6; valid_F3 <= 1'b1; end
                  6, 9: begin lcd_data_F3 <= `F3_COLOR_7; valid_F3 <= 1'b1; end
                  8: begin lcd_data_F3 <= `F3_COLOR_10; valid_F3 <= 1'b1; end
                endcase
               10: case (x_coord)
                  2, 5, 7, 8: begin lcd_data_F3 <= `F3_COLOR_6; valid_F3 <= 1'b1; end
                  3: begin lcd_data_F3 <= `F3_COLOR_10; valid_F3 <= 1'b1; end
                  4: begin lcd_data_F3 <= `F3_COLOR_13; valid_F3 <= 1'b1; end
                  6: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  9, 10, 11: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                endcase
               11: case (x_coord)
                  2, 5, 9, 11: begin lcd_data_F3 <= `F3_COLOR_4; valid_F3 <= 1'b1; end
                  3, 4, 6, 8: begin lcd_data_F3 <= `F3_COLOR_5; valid_F3 <= 1'b1; end
                  7: begin lcd_data_F3 <= `F3_COLOR_17; valid_F3 <= 1'b1; end
                  10: begin lcd_data_F3 <= `F3_COLOR_7; valid_F3 <= 1'b1; end
                endcase
               12: case (x_coord)
                  2, 7: begin lcd_data_F3 <= `F3_COLOR_8; valid_F3 <= 1'b1; end
                  3: begin lcd_data_F3 <= `F3_COLOR_11; valid_F3 <= 1'b1; end
                  4: begin lcd_data_F3 <= `F3_COLOR_14; valid_F3 <= 1'b1; end
                  10: begin lcd_data_F3 <= `F3_COLOR_3; valid_F3 <= 1'b1; end
                endcase
            endcase
        end
    end
end

`define F4_COLOR_1   21'h1F3F1F
`define F4_COLOR_2   21'h40602
`define F4_COLOR_3   21'h101006
`define F4_COLOR_4   21'h1C1102
`define F4_COLOR_5   21'h1F1704
`define F4_COLOR_6   21'h80802
`define F4_COLOR_7   21'h180F02
`define F4_COLOR_8   21'hC170B
`define F4_COLOR_9   21'hB140A
`define F4_COLOR_10   21'h90A04
`define F4_COLOR_11   21'hE0B02
`define F4_COLOR_12   21'h151005
`define F4_COLOR_13   21'h112110
`define F4_COLOR_14   21'h1C1102
`define F4_COLOR_15   21'h1F200B

reg valid_F4;
reg [23:0] lcd_data_F4;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_data_F4 <= 24'd0;
        valid_F4 <= 1'b0;
    end else begin
        lcd_data_F4 <= 24'd0;
        valid_F4 <= 1'b0;
        if (inside_sprite && enable_frame4) begin
            valid_F4 <= 1'b0;
            case (y_coord)
               2: case (x_coord)
                  5, 7, 10: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  6: begin lcd_data_F4 <= `F4_COLOR_4; valid_F4 <= 1'b1; end
                  8: begin lcd_data_F4 <= `F4_COLOR_10; valid_F4 <= 1'b1; end
                endcase
               3: case (x_coord)
                  2, 3, 6, 7, 9, 10: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  4: begin lcd_data_F4 <= `F4_COLOR_5; valid_F4 <= 1'b1; end
                  5: begin lcd_data_F4 <= `F4_COLOR_6; valid_F4 <= 1'b1; end
                  8: begin lcd_data_F4 <= `F4_COLOR_11; valid_F4 <= 1'b1; end
                endcase
               4: case (x_coord)
                  2, 6, 7, 8, 9, 11: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  3, 4: begin lcd_data_F4 <= `F4_COLOR_4; valid_F4 <= 1'b1; end
                  5: begin lcd_data_F4 <= `F4_COLOR_6; valid_F4 <= 1'b1; end
                  10: begin lcd_data_F4 <= `F4_COLOR_14; valid_F4 <= 1'b1; end
                endcase
               5: case (x_coord)
                  3, 11: begin lcd_data_F4 <= `F4_COLOR_3; valid_F4 <= 1'b1; end
                  4: begin lcd_data_F4 <= `F4_COLOR_5; valid_F4 <= 1'b1; end
                  5, 6, 9: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  7: begin lcd_data_F4 <= `F4_COLOR_4; valid_F4 <= 1'b1; end
                  8: begin lcd_data_F4 <= `F4_COLOR_10; valid_F4 <= 1'b1; end
                  10: begin lcd_data_F4 <= `F4_COLOR_15; valid_F4 <= 1'b1; end
                endcase
               6: case (x_coord)
                  2, 3, 5, 6, 10: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  4, 9: begin lcd_data_F4 <= `F4_COLOR_5; valid_F4 <= 1'b1; end
                  7: begin lcd_data_F4 <= `F4_COLOR_3; valid_F4 <= 1'b1; end
                  8: begin lcd_data_F4 <= `F4_COLOR_12; valid_F4 <= 1'b1; end
                endcase
               7: case (x_coord)
                  2: begin lcd_data_F4 <= `F4_COLOR_3; valid_F4 <= 1'b1; end
                  3, 5, 6, 7, 11: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  4: begin lcd_data_F4 <= `F4_COLOR_4; valid_F4 <= 1'b1; end
                  8: begin lcd_data_F4 <= `F4_COLOR_12; valid_F4 <= 1'b1; end
                  9, 10: begin lcd_data_F4 <= `F4_COLOR_5; valid_F4 <= 1'b1; end
                endcase
               8: case (x_coord)
                  3, 4, 7, 8, 9: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  5: begin lcd_data_F4 <= `F4_COLOR_7; valid_F4 <= 1'b1; end
                  6, 10: begin lcd_data_F4 <= `F4_COLOR_5; valid_F4 <= 1'b1; end
                  11: begin lcd_data_F4 <= `F4_COLOR_3; valid_F4 <= 1'b1; end
                endcase
               9: case (x_coord)
                  3: begin lcd_data_F4 <= `F4_COLOR_4; valid_F4 <= 1'b1; end
                  4: begin lcd_data_F4 <= `F4_COLOR_3; valid_F4 <= 1'b1; end
                  5, 6, 7, 8, 9, 11: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  10: begin lcd_data_F4 <= `F4_COLOR_14; valid_F4 <= 1'b1; end
                endcase
               10: case (x_coord)
                  3, 4, 6: begin lcd_data_F4 <= `F4_COLOR_4; valid_F4 <= 1'b1; end
                  5: begin lcd_data_F4 <= `F4_COLOR_3; valid_F4 <= 1'b1; end
                  7, 8, 9, 11: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  10: begin lcd_data_F4 <= `F4_COLOR_5; valid_F4 <= 1'b1; end
                endcase
               11: case (x_coord)
                  4: begin lcd_data_F4 <= `F4_COLOR_2; valid_F4 <= 1'b1; end
                  5: begin lcd_data_F4 <= `F4_COLOR_8; valid_F4 <= 1'b1; end
                  6, 9, 10, 11: begin lcd_data_F4 <= `F4_COLOR_9; valid_F4 <= 1'b1; end
                  8: begin lcd_data_F4 <= `F4_COLOR_13; valid_F4 <= 1'b1; end
                endcase
            endcase
        end
    end
end
`define F5_COLOR_1   21'h1F3F1F
`define F5_COLOR_2   21'h40602
`define F5_COLOR_3   21'h101006
`define F5_COLOR_4   21'h180F02
`define F5_COLOR_5   21'h60703
`define F5_COLOR_6   21'hE0E06
`define F5_COLOR_7   21'h1C1102
`define F5_COLOR_8   21'h1F3F1F
`define F5_COLOR_9   21'h101006
`define F5_COLOR_10   21'h1F3E1F
`define F5_COLOR_11   21'h1E3C1E
`define F5_COLOR_12   21'h50602

reg valid_F5;
reg [23:0] lcd_data_F5;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_data_F5 <= 24'd0;
        valid_F5 <= 1'b0;
    end else begin
        lcd_data_F5 <= 24'd0;
        valid_F5 <= 1'b0;
        if (inside_sprite && enable_frame5) begin
            valid_F5 <= 1'b0;
            case (y_coord)
               2: case (x_coord)
                  9: begin lcd_data_F5 <= `F5_COLOR_8; valid_F5 <= 1'b1; end
                endcase
               3: case (x_coord)
                  4: begin lcd_data_F5 <= `F5_COLOR_4; valid_F5 <= 1'b1; end
                  5, 6, 7, 8, 9, 10: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  11: begin lcd_data_F5 <= `F5_COLOR_11; valid_F5 <= 1'b1; end
                endcase
               4: case (x_coord)
                  4: begin lcd_data_F5 <= `F5_COLOR_5; valid_F5 <= 1'b1; end
                  5, 8, 10: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  6, 7: begin lcd_data_F5 <= `F5_COLOR_3; valid_F5 <= 1'b1; end
                  9: begin lcd_data_F5 <= `F5_COLOR_9; valid_F5 <= 1'b1; end
                endcase
               5: case (x_coord)
                  3, 4, 6, 7, 8, 9, 10: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  5: begin lcd_data_F5 <= `F5_COLOR_3; valid_F5 <= 1'b1; end
                endcase
               6: case (x_coord)
                  3, 4, 7, 8: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  5, 6: begin lcd_data_F5 <= `F5_COLOR_3; valid_F5 <= 1'b1; end
                endcase
               7: case (x_coord)
                  4, 7: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  5, 6, 8: begin lcd_data_F5 <= `F5_COLOR_3; valid_F5 <= 1'b1; end
                endcase
               8: case (x_coord)
                  2, 4, 5, 6, 10, 11: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  3, 8: begin lcd_data_F5 <= `F5_COLOR_3; valid_F5 <= 1'b1; end
                  7, 9: begin lcd_data_F5 <= `F5_COLOR_7; valid_F5 <= 1'b1; end
                endcase
               9: case (x_coord)
                  5, 6, 10: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  7, 8: begin lcd_data_F5 <= `F5_COLOR_3; valid_F5 <= 1'b1; end
                  9: begin lcd_data_F5 <= `F5_COLOR_7; valid_F5 <= 1'b1; end
                  11: begin lcd_data_F5 <= `F5_COLOR_12; valid_F5 <= 1'b1; end
                endcase
               10: case (x_coord)
                  4: begin lcd_data_F5 <= `F5_COLOR_6; valid_F5 <= 1'b1; end
                  5, 6, 8, 10: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  7: begin lcd_data_F5 <= `F5_COLOR_3; valid_F5 <= 1'b1; end
                  9: begin lcd_data_F5 <= `F5_COLOR_10; valid_F5 <= 1'b1; end
                endcase
               11: case (x_coord)
                  5, 8: begin lcd_data_F5 <= `F5_COLOR_2; valid_F5 <= 1'b1; end
                  7: begin lcd_data_F5 <= `F5_COLOR_3; valid_F5 <= 1'b1; end
                endcase
            endcase
        end
    end
end
`define F6_COLOR_1   21'h1F3F1F
`define F6_COLOR_2   21'h40602
`define F6_COLOR_3   21'h1D3B1D
`define F6_COLOR_4   21'h193219
`define F6_COLOR_5   21'hD0E05
`define F6_COLOR_6   21'h193219
`define F6_COLOR_7   21'h101006
`define F6_COLOR_8   21'h142814
`define F6_COLOR_9   21'hE0A02
`define F6_COLOR_10   21'hF1006
`define F6_COLOR_11   21'h12170A
`define F6_COLOR_12   21'h1A3419
`define F6_COLOR_13   21'h1C1102
`define F6_COLOR_14   21'h180F02
`define F6_COLOR_15   21'h70C05

reg valid_F6;
reg [23:0] lcd_data_F6;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_data_F6 <= 24'd0;
        valid_F6 <= 1'b0;
    end else begin
        lcd_data_F6 <= 24'd0;
        valid_F6 <= 1'b0;
        if (inside_sprite && enable_frame6) begin
            valid_F6 <= 1'b0;
            case (y_coord)
               2: case (x_coord)
                  9: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                endcase
               3: case (x_coord)
                  6, 9: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                  7: begin lcd_data_F6 <= `F6_COLOR_8; valid_F6 <= 1'b1; end
                endcase
               4: case (x_coord)
                  4: begin lcd_data_F6 <= `F6_COLOR_5; valid_F6 <= 1'b1; end
                  6, 7: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                  9: begin lcd_data_F6 <= `F6_COLOR_12; valid_F6 <= 1'b1; end
                  10: begin lcd_data_F6 <= `F6_COLOR_15; valid_F6 <= 1'b1; end
                endcase
               5: case (x_coord)
                  5: begin lcd_data_F6 <= `F6_COLOR_7; valid_F6 <= 1'b1; end
                  6, 7, 8, 9, 10: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                endcase
               6: case (x_coord)
                  3, 4: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                  5, 6: begin lcd_data_F6 <= `F6_COLOR_7; valid_F6 <= 1'b1; end
                  7: begin lcd_data_F6 <= `F6_COLOR_8; valid_F6 <= 1'b1; end
                endcase
               7: case (x_coord)
                  4, 7, 8: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                  5, 6: begin lcd_data_F6 <= `F6_COLOR_7; valid_F6 <= 1'b1; end
                endcase
               8: case (x_coord)
                  3: begin lcd_data_F6 <= `F6_COLOR_3; valid_F6 <= 1'b1; end
                  4, 5, 10: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                  7: begin lcd_data_F6 <= `F6_COLOR_9; valid_F6 <= 1'b1; end
                  8: begin lcd_data_F6 <= `F6_COLOR_7; valid_F6 <= 1'b1; end
                  9: begin lcd_data_F6 <= `F6_COLOR_13; valid_F6 <= 1'b1; end
                endcase
               9: case (x_coord)
                  3, 5: begin lcd_data_F6 <= `F6_COLOR_4; valid_F6 <= 1'b1; end
                  4: begin lcd_data_F6 <= `F6_COLOR_6; valid_F6 <= 1'b1; end
                  6, 10: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                  7: begin lcd_data_F6 <= `F6_COLOR_10; valid_F6 <= 1'b1; end
                  8: begin lcd_data_F6 <= `F6_COLOR_11; valid_F6 <= 1'b1; end
                  9: begin lcd_data_F6 <= `F6_COLOR_14; valid_F6 <= 1'b1; end
                endcase
               10: case (x_coord)
                  4, 7: begin lcd_data_F6 <= `F6_COLOR_7; valid_F6 <= 1'b1; end
                  5, 6: begin lcd_data_F6 <= `F6_COLOR_2; valid_F6 <= 1'b1; end
                endcase
               11: case (x_coord)
                  7: begin lcd_data_F6 <= `F6_COLOR_8; valid_F6 <= 1'b1; end
                endcase
            endcase
        end
    end
end
endmodule