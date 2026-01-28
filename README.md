
# Space Invader on a Tang Nano 20k 

This project implements a Space Invader game supposed to run on a tang nano 20k FPGA.  It uses differents base code that I did not implement : 
  
 - A risc-v (32-bit) core from https://github.com/YosysHQ/picorv32. 
 - A risc-v wrapper from https://github.com/grughuhler/picorv32_tang_nano_20k, along with : 
 	- its top module
 	- its ram modules 
 	- its reset controller
 	- its count-down-timers
 	- the base code used to generate the C binaries to inject in the ram. 
 - A lcd_rgb module from https://github.com/sipeed/TangNano-20K-example/tree/main/rgb_lcd/lcd_800_400 along with : 
 	- its top module 
 	- its lcd controller module 
 	- its pll_40m module

The FPGA game takes its input from the specified pins : 
 - pin 73 : button 1 
 - pin 74 : move left  
 - pin 71 : move right  
 - pin 75 : move up ( not currently used )  
 - pin 72 : move down ( not currently used )  
 
I implemented small python scripts that can generate the SystemVerilog code in charge of rendering the the different gaphics entities. They can be found in the [graphics_creation](./graphics_creation) directory.
  
I currently use a ESP32 to recieve bluetooth inputs from a controller and transfer them to the FPGA. The code flashed into the esp32 can be found in the [esp32_controller](./esp32_controller) directory.

The SRAM is initialized by the C code and then the Verilog build process. The C code imported in the FPGA risc-v processor can be found in the [gowin_fpga_project](./gowin_fpga_project) directory.

