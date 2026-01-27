#include "buttons.h"

#define BUTTONS ((volatile unsigned char *) 0x80000020)

unsigned char get_buttons_state()
{
   unsigned char buts = *BUTTONS;
   return buts;
}


char button1_pushed(){
   return *BUTTONS && 0b1 == 1; 
}