#include "game_state.h"

#define GAME_STATE ((volatile unsigned char *) 0x80000024) //00 -> start screen, 01 -> game running, 10 -> freeze, 11 -> end game
#define GAME_STATUS ((volatile unsigned char *) 0x80000028) // 00 game running,  01 -> game over ->  10 game ended enemies dead,  100 -> life lost ???
#define GAME_SCORE ((volatile unsigned char *) 0x8000002C) // bits 0:13 -> player score
#define GAME_HIGH_SCORE ((volatile unsigned char *) 0x80000030) // bits 0:13 -> high score


void freeze_game(){
    *GAME_STATE = 0b10;
}

void start_game(){
    *GAME_STATE = 0b0;
    *GAME_STATE = 0b1;
}

char is_game_over(){
    return *GAME_STATUS == 0b1;
}

void show_game_over(){
    *GAME_STATE = 0b11;
}
    void set_high_score(unsigned int score){
    *GAME_HIGH_SCORE = 0;
    *GAME_HIGH_SCORE = score & 0x3FFF;
}
unsigned int get_score(){
    return *GAME_SCORE; 
}

char game_succeed(){
    return *GAME_STATUS == 0b10;
}

void show_start_screen(){
    *GAME_STATE = 0b0;
}