module wall_pixel_mod
#(
    parameter Y_MAX = 490,
    parameter FIG_X0 = 637,
    parameter FIG_Y0 = 0, 
    parameter FIG_WIDTH = 60, 
    parameter FIG_HEIGHT = 60 
)  
( 
    input  wire         clk,    
    input  wire         rst_n,  
    input  wire [11:0]  lcd_xpos,
    input  wire [11:0]  lcd_ypos,
    input  wire         enable,
    input  wire         freeze,

    output wire [23:0]  wall_pixel,   // RGB pixel color
    output wire         pixel_valid
);

`define RGB565(R,G,B) {3'b0, R, 2'b0, G, 3'b0, B}

`define BORDER             24'h000000
`define GLACE             `RGB565(5'd31, 6'd20, 5'd25)
`define DOUGH              24'he8a662
`define BLUE_SPRINKEL      24'h8abff0
`define RED_SPRINKEL       24'heb9595
`define YELLOW_SPRINKEL    24'hffff60
`define GREEN_SPRINKEL     24'h9eff60
`define GREEN_BAD          `RGB565(5'd0, 6'd61, 5'd0)

reg [11:0] lcd_x, lcd_y;
reg signed [11:0] position_x, position_y;
reg [5:0] x_coord;
reg [4:0] y_coord;
reg inside_sprite;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_x <= 12'd0;
        lcd_y <= 12'd0;
        position_x <= 12'd0;
        position_y <= 12'd0;
        x_coord <= 6'd0;
        y_coord <= 5'd0;
        inside_sprite <= 1'b0;
    end else begin
        lcd_x <= lcd_xpos;
        lcd_y <= lcd_ypos;

        position_x <= $signed({1'b0, lcd_xpos}) - $signed({1'b0, FIG_X0});
        position_y <= $signed({1'b0, lcd_ypos}) - $signed({1'b0, FIG_Y0});

        x_coord <= (position_x >= 0) ? (position_x >>> 2) : 6'd0;
        y_coord <= (position_y >= 0) ? (position_y >>> 2) : 5'd0;

        inside_sprite <= enable &&
                           (position_x >= 0 && position_x < FIG_WIDTH) &&
                           (position_y >= 0 && position_y < FIG_HEIGHT) &&
                           (x_coord >= 1 && x_coord <= 14) &&
                           (y_coord >= 1 && y_coord <= 13);
    end
end

reg [23:0] lcd_data;
reg valid;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_data <= 24'd0;
        valid <= 1'b0;
    end else begin
        lcd_data <=  24'd0;
        valid <= 1'b0;
        if (inside_sprite) begin
            case (x_coord)
                1: case (y_coord)
                        6,7,8,9: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                   endcase

                2: case (y_coord)
                        4,5,10,11: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        6,9: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        7: begin
                            lcd_data <= `RED_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        8: begin
                            lcd_data <= `BLUE_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                3: case (y_coord)
                        3,12: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        4,6,7,8,9,10,11: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        5: begin
                            lcd_data <= `BLUE_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                4: case (y_coord)
                        2,13: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        3,4,5,6,8,9,10,12: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        7,11: begin
                            lcd_data <= `GREEN_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                5: case (y_coord)
                        2,13: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        3,4,5,6,9,10,11,12: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        7,8: begin
                            lcd_data <= `DOUGH;
                            valid    <= 1'b1;
                        end
                        3,9: begin
                            lcd_data <= `BLUE_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                6: case (y_coord)
                        1,7,8,14: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        2,3,5,10,12,13: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        6,9: begin
                            lcd_data <= `DOUGH;
                            valid    <= 1'b1;
                        end
                        4,11: begin
                            lcd_data <= `RED_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                7: case (y_coord)
                        1,6,9,14: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        2,3,4,5,10,13: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        12: begin
                            lcd_data <= `RED_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        11: begin
                            lcd_data <= `BLUE_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        3: begin
                            lcd_data <= `YELLOW_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                8: case (y_coord)
                        1,6,9,14: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        2,3,4,10,11,12,13: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        5: begin
                            lcd_data <= `RED_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                9: case (y_coord)
                        1,7,8,14: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        2,4,5,9,11,12: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        6,9: begin
                            lcd_data <= `DOUGH;
                            valid    <= 1'b1;
                        end
                        3: begin
                            lcd_data <= `BLUE_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        10: begin
                            lcd_data <= `YELLOW_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        6,13: begin
                            lcd_data <= `GREEN_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                10: case (y_coord)
                        2,13: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        3,4,6,7,9,10,11: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        5,12: begin
                            lcd_data <= `YELLOW_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        8: begin
                            lcd_data <= `GREEN_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                11: case (y_coord)
                        2,13: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        5,6,7,8,9: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        3,12: begin
                            lcd_data <= `DOUGH;
                            valid    <= 1'b1;
                        end
                        4,10: begin
                            lcd_data <= `RED_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        7: begin
                            lcd_data <= `BLUE_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        11: begin
                            lcd_data <= `GREEN_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                12: case (y_coord)
                        3,12: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        4,10,11: begin
                            lcd_data <= `DOUGH;
                            valid    <= 1'b1;
                        end
                        6,7,9: begin
                            lcd_data <= `GLACE;
                            valid    <= 1'b1;
                        end
                        8: begin
                            lcd_data <= `RED_SPRINKEL;
                            valid    <= 1'b1;
                        end
                        5: begin
                            lcd_data <= `YELLOW_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                13: case (y_coord)
                        4,5,10,11: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                        6,7,8: begin
                            lcd_data <= `DOUGH;
                            valid    <= 1'b1;
                        end
                        9: begin
                            lcd_data <= `YELLOW_SPRINKEL;
                            valid    <= 1'b1;
                        end
                   endcase

                14: case (y_coord)
                        6,7,8,9: begin
                            lcd_data <= `BORDER;
                            valid    <= 1'b1;
                        end
                   endcase

                default: begin
                    lcd_data <= `GREEN_BAD;
                    valid    <= 1'b0;
                end
            endcase
        end
    end
end

assign wall_pixel = lcd_data;
assign pixel_valid = valid;

endmodule