/* Copyright 2024 Grug Huhler.  License SPDX BSD-2-Clause.

   This program shows counting on the LEDs of the Tang Nano
   9K FPGA development board.

   Function foo lets one see stores of different size and alignment by
   looking at the wstrb signals from the pico32rv.
*/

#include "leds.h"
#include "buttons.h"
#include "countdown_timer.h"
#include "game_state.h"

enum {START_SCREEN, IN_GAME, GAME_OVER} state = START_SCREEN;

unsigned int high_score = 0; 

void delay_start_screen(){
    cdt_delay(2*CLK_FREQ);
}


void start_screen_state(){
    if(button1_pushed()) {
        state = IN_GAME;
        start_game();
    }
}

void in_game_state(){
    if (game_succeed()){
        cdt_delay(2*CLK_FREQ);
        start_game();
    }
    else if(is_game_over()){
        freeze_game();
        state = GAME_OVER;
    }
}

void game_over_state(){

    unsigned int score = get_score();


    if(score > high_score){
        high_score = score;
    }
    set_high_score(high_score);
    show_game_over();

    cdt_delay(3*CLK_FREQ);

    if(button1_pushed()) {
        show_start_screen();
        delay_start_screen();
        state = START_SCREEN;
    }
}
int main() {
    set_high_score(high_score);
    show_start_screen();
    
    delay_start_screen();
    while(1){
        switch(state){
            case START_SCREEN : 
                start_screen_state();
            break; 
            case IN_GAME : 
                in_game_state();
            break;
            case GAME_OVER : 
                game_over_state();
            break;
        }
    }
  return 0;
}
