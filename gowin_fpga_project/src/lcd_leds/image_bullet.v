module bullet_pixel_mod
#(
    parameter X_MAX = 60, 
    parameter FIG_X0 = 715, 
    parameter FIG_WIDTH = 27,
    parameter FIG_HEIGHT = 4, 
    parameter ANIM_FRAME = 20000, 
    parameter MIN_WAIT_TIME = 30000000 

)  
( 
	input  wire			clk,	
	input  wire			rst_n,	
	input  wire	[11:0]	lcd_xpos,
	input  wire	[11:0]	lcd_ypos,
	input  wire	[11:0]	y_pos,
	input  wire		    enable,
	input  wire		    collision,
	input  wire		    shoot,
	input  wire		    freeze,

	output wire  [23:0]	bullet_pixel,
	output wire  	    pixel_valid
);

reg [11:0] position_x = FIG_X0;
reg [11:0] position_y;

reg [23:0] lcd_data;
reg valid;

assign bullet_pixel = lcd_data;
assign pixel_valid = valid;

reg shooting; 
reg inside_sprite;

reg [11:0] lcd_x, lcd_y, y_pos_r;

//pipeline inputs
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        lcd_x <= 0;
        lcd_y <= 0;
        inside_sprite <= 1'b0;
        y_pos_r <= 0;
    end else begin
        lcd_x <= lcd_xpos;
        lcd_y <= lcd_ypos;
        y_pos_r <= y_pos;

        inside_sprite <=
            (lcd_x >= position_x) &&
            (lcd_x < position_x + FIG_WIDTH) &&
            (lcd_y >= position_y) &&
            (lcd_y < position_y + FIG_HEIGHT);
    end
end

// color the bullet
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid <= 1'b0;
        lcd_data <= 24'd0;
    end else begin
        valid <= 1'b0;
        lcd_data <= 24'd0;
       if (inside_sprite && shooting && enable)
        begin
            valid <= 1'b1;
            lcd_data    <= ((24'd23 << 20) | (24'd62 << 8) | 24'd26);
        end
    end
end

reg [19:0] counter;
reg [25:0] wait_counter;
reg in_waiting = 1'b1;


wire frame_tick = (lcd_xpos == 0 && lcd_ypos == 0);

// shooting logic : one shoot at a time, if is shouting, does not count. shooting stop when collision, !enable, rst or end reached
always_ff @(posedge clk or negedge rst_n) begin 
    if (!rst_n || !enable) begin 
        shooting <= 1'b0;
        wait_counter <= 26'd0;
        in_waiting   <= 1'b1;
    end else begin 
        if (shooting && (collision || position_x == X_MAX)) begin
            shooting <= 1'b0;
        end
        else if (shoot && !shooting && !in_waiting ) begin
            shooting <= 1'b1;
            position_y <= y_pos_r + 9;
            wait_counter <= 26'd0;
        end
        else begin 
            if (wait_counter <= MIN_WAIT_TIME) begin
                wait_counter <= wait_counter + 1'b1;
            end                
            in_waiting <= (wait_counter <= MIN_WAIT_TIME);
        end
    end
end

// control the position of the shoot
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n || !enable) begin
        counter <= 19'b0;
        position_x <= FIG_X0;
    end else if (freeze)   begin 
        counter <= 19'b0;
        position_x <= position_x;
    end else begin
        if(shooting) begin 
            if (frame_tick) begin 
                counter <= counter + 1'b1;
                if (counter >= ANIM_FRAME) begin
                    counter <= 19'b0;
                    if (position_x > X_MAX) begin
                        position_x <= position_x - 1'b1;
                    end
                end
            end
        end else begin 
            position_x <= FIG_X0;
            counter <= 19'b0;
        end 
    end
 end
endmodule