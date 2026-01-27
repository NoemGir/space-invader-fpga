
import enemies_struct::*;

module enemy_control #(
    parameter MAX_Y = 460,
    parameter MAX_X = 610,
    parameter  NB_ENEMY_Y = 10,
    parameter  NB_ENEMY_X = 5,
    parameter  ENEMY_WIDTH    = 60,
    parameter  ENEMY_HEIGHT    = 60,
    parameter  X0         = 75,
    parameter  Y0         = 65,
    parameter  MOUV_SPEED = 130000,
    parameter  SLOW_SPEED = 20,
    parameter  MOUV_STEP = 13,
    parameter  LEFT_MOUV_STEP = 20,
    parameter SPEED_REDUCTION = 2000
)(
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    input  wire freeze,
    input  wire frame_rate, 
    input  wire	[11:0]	killed_enemy_x,
    input  wire	[11:0]	killed_enemy_y,
    input  wire valid_enemy_collision,

    output enemy_t enemies[NB_ENEMY_Y][NB_ENEMY_X],
    output reg   [2:0]  finished,
    output reg   [1:0] plus_score,

    output reg [11:0] dead_enemy_x,
    output reg [11:0] dead_enemy_y
);


reg [5:0] dead_counter;
reg end_reached = 1'b0;
wire all_dead = dead_counter == NB_ENEMY_Y*NB_ENEMY_X;


always @(posedge clk or negedge rst_n) begin 
    if (!rst_n || !enable)
        finished = 3'b0;
    else begin 
        if (end_reached) finished <= 3'b001;
        else if (all_dead) finished <= 3'b010;
    end 
end


logic [$clog2(NB_ENEMY_Y)-1:0] cur_row, killed_enemy_row;
logic [$clog2(NB_ENEMY_X)-1:0] cur_col, killed_enemy_col;

reg move_tick;
reg [25:0] move_counter;
reg slow_move_tick;
reg [5:0] slow_counter;

reg [25:0] dynamique_speed = MOUV_SPEED;

reg [11:0] dyn_ENEMY_WIDTH, dyn_ENEMY_HEIGHT, killed_enemy_x_r, killed_enemy_y_r;


wire move_freeze = freeze || valid_enemy_collision || collision_detected; //|| in_anim;

reg collision_detected; 


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin 
        collision_detected <= 0;
        killed_enemy_x_r <= 0;
        killed_enemy_y_r <= 0;
    end
    else begin 
        collision_detected <= valid_enemy_collision && (killed_enemy_x != 0 && killed_enemy_y != 0);
        killed_enemy_x_r <= killed_enemy_x;
        killed_enemy_y_r <= killed_enemy_y;
    end
end

reg vertical_dir; // 1 = moving down, 0 = moving up
reg step_right_pending; // 1 = next tick all enemies move 1 step right
reg [NB_ENEMY_X-1 : 0 ] move_right_col;  
reg row_finished;

reg y_end_reached; 

reg [6:0] dyn_slow_speed; 

// enemy mouvement and appearance manager

always @(posedge clk or negedge rst_n) begin
    if (!rst_n || !enable) begin
        for (int r = 0; r < NB_ENEMY_Y; r++) begin
            for (int c = 0; c < NB_ENEMY_X; c++) begin
                enemies[r][c].x     <= X0 + c * ENEMY_WIDTH;
                enemies[r][c].y     <= Y0 + r * ENEMY_HEIGHT;
                enemies[r][c].alive <= 1'b1;
                if (c == 0 ) 
                    enemies[r][c].id <= 2'b10;
                else if ( c <= 2)
                    enemies[r][c].id <= 2'b01;
                else 
                    enemies[r][c].id <= 2'b00;
            end
        end

        cur_col    <= NB_ENEMY_X -1; // start bottom
        cur_row    <= 6'd0;
        move_right_col <=  NB_ENEMY_X -1;
        end_reached <= 1'b0;
        row_finished <= 1'b0;
        plus_score <= 2'b00;
        dynamique_speed <= MOUV_SPEED;
        dyn_slow_speed <= SLOW_SPEED;
        dead_enemy_x <= 12'd0;
        dead_enemy_y <= 12'd0;
        y_end_reached <= 1'b0;
        dead_counter <= 6'd0;
    end
    else  begin 
    dead_enemy_x <= 12'd0;
    dead_enemy_y <= 12'd0;
    plus_score <= 2'b00;
        if (enable && move_tick && !move_freeze) begin
            if(!step_right_pending) begin 
                if (vertical_dir) begin 
                    // move down enemy 
                    if (enemies[cur_row][cur_col].alive && enemies[cur_row][cur_col].y + ENEMY_HEIGHT + MOUV_STEP >= MAX_Y) 
                        y_end_reached <= 1'b1;
                      
                    if(!row_finished) begin 
                        enemies[cur_row][cur_col].y <= enemies[cur_row][cur_col].y + MOUV_STEP;
                    end
                    else if (cur_col <= 0 && y_end_reached)  begin 
                            vertical_dir <= 0; // start moving up
                            step_right_pending <= 1'b1;
                            y_end_reached <= 1'b0;
                    end
                    if (cur_row <= 0) 
                        row_finished <= 1'b1;
                    else 
                         cur_row <= cur_row - 1'b1;
                    
                    if(slow_move_tick && cur_row <= 0) begin
                        cur_row <= NB_ENEMY_Y-1;
                        cur_col <= (cur_col == 0) ? NB_ENEMY_X -1 : cur_col - 1'b1;
                        row_finished <= 1'b0;
                    end
                end
                else begin 
                    // move up enemy
                    if (enemies[cur_row][cur_col].alive && enemies[cur_row][cur_col].y <= MOUV_STEP*2) begin 
                        y_end_reached <= 1'b1;
                    end
                    if(!row_finished) begin 
                        enemies[cur_row][cur_col].y <= enemies[cur_row][cur_col].y - MOUV_STEP;
                    end else if (cur_col <= 0 && y_end_reached)  begin 
                            vertical_dir <= 1;
                            step_right_pending <= 1'b1;
                            y_end_reached <= 1'b0;
                    end
                    if (cur_row >= NB_ENEMY_Y-1) 
                        row_finished <= 1'b1;
                    else 
                         cur_row <= cur_row + 1'b1;

                      if (slow_move_tick && cur_row >= NB_ENEMY_Y-1) begin
                            cur_row <= 6'd0;
                            cur_col <= (cur_col == 0) ? NB_ENEMY_X -1 : cur_col - 1'b1;;
                            row_finished <= 1'b0;
                     end 
                end
            end
            else begin 
                if(slow_move_tick) begin 
                    for (int r = 0; r < NB_ENEMY_Y; r++) begin
                        enemies[r][move_right_col].x  <= enemies[r][move_right_col].x + LEFT_MOUV_STEP;
                        if ( enemies[r][move_right_col].alive && enemies[r][move_right_col].x + ENEMY_WIDTH + LEFT_MOUV_STEP >= MAX_X) begin
                            end_reached <= 1'b1;
                        end
                    end
                    if (move_right_col == 0 ) begin 
                        move_right_col <=  NB_ENEMY_X -1'b1;
                        step_right_pending <= 1'b0;
                        cur_col <= NB_ENEMY_X;
                        row_finished <= 1'b0;
                        y_end_reached <= 1'b0;
                        if (vertical_dir)  
                            cur_row <= NB_ENEMY_Y-1'b1;
                        else  
                            cur_row <= 6'd0;
                    end
                    else 
                        move_right_col <= move_right_col - 1'b1; 
                end
            end
        end
        if (collision_detected || valid_enemy_collision ) begin
            for (int r = 0; r < NB_ENEMY_Y; r++) begin
                for (int c = 0; c < NB_ENEMY_X; c++) begin
                    if (enemies[r][c].alive &&
                        killed_enemy_x_r >= enemies[r][c].x 
                        && killed_enemy_x_r < enemies[r][c].x + ENEMY_WIDTH 
                         && killed_enemy_y_r >= enemies[r][c].y 
                         && killed_enemy_y_r < enemies[r][c].y + ENEMY_HEIGHT) begin 

                            enemies[r][c].alive <= 1'b0;
                            dynamique_speed     <= dynamique_speed - SPEED_REDUCTION;
                            dead_enemy_x <= enemies[r][c].x;
                            dead_enemy_y <= enemies[r][c].y;
                            if( enemies[r][c].id == 2'b00)
                                plus_score       <= 2'b01;
                            else if( enemies[r][c].id == 2'b01)
                                plus_score       <= 2'b10;
                            else 
                                plus_score       <= 2'b11;
                            dead_counter <= dead_counter + 1'b1;
                                 
                            if (dead_counter == 41 ||
                                dead_counter == 36 ||
                                dead_counter == 31 ||
                                dead_counter == 26 ||
                                dead_counter == 21 ||
                                dead_counter == 16 ||
                                dead_counter == 11 ||
                                dead_counter == 6 ||
                                dead_counter == 1) begin 
                                dyn_slow_speed <= dyn_slow_speed - 1'b1;
                            end
                    end
                end
            end
        end else begin 
            plus_score <= 2'b00;
        end
    end
end


// counter for animation speed 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n || !enable) begin
        move_counter    <= 26'd0;
        slow_counter    <= 6'd0;
        move_tick       <= 1'b0;
        slow_move_tick  <= 1'b0;
    end else begin 
        move_tick      <= 1'b0;
        slow_move_tick <= 1'b0;

        if (frame_rate) begin
            move_counter <= move_counter + 1'b1;

            if (move_counter >= dynamique_speed) begin
                move_counter <= 26'd0;
                move_tick <= 1'b1;

                if (slow_counter >= dyn_slow_speed) begin
                    slow_counter <= 6'd0;
                    slow_move_tick <= 1'b1;
                end else begin
                    slow_counter <= slow_counter + 1'b1;
                end
            end
        end
    end
end




endmodule