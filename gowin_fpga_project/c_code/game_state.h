#ifndef GAME_STATE_H
#define CGAME_STATE_H

extern void freeze_game();
extern void start_game();
extern void show_game_over();
extern void set_high_score(unsigned int high_score);
extern unsigned int get_score();
extern char game_succeed();
extern char is_game_over();
extern void show_start_screen();


#endif /* GAME_STATE */

