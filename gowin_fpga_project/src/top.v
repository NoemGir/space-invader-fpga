/* Copyright 2024 Grug Huhler.  License SPDX BSD-2-Clause. */

module top (
            input wire        clk,
            input wire        reset_button,
            input wire        uart_rx,
            output wire       uart_tx,
            output wire [5:0] leds,
            input wire [4:0] buttons,

            output [4:0]  	lcd_r,
            output [5:0]  	lcd_g,
            output [4:0]  	lcd_b,
            output          lcd_de,
            output          lcd_hsync,
            output          lcd_vsync,
            output          lcd_clk,
            output			lcd_bl
);

   // This include gets SRAM_ADDR_WIDTH and CLK_FREQ from software build process
   `include "sys_parameters.v"

   parameter BARREL_SHIFTER = 0;
   parameter ENABLE_MUL = 0;
   parameter ENABLE_DIV = 0;
   parameter ENABLE_FAST_MUL = 0;
   parameter ENABLE_COMPRESSED = 0;
   parameter ENABLE_IRQ_QREGS = 0;

   parameter        MEMBYTES = 4*(1 << SRAM_ADDR_WIDTH); 
   parameter [31:0] STACKADDR = (MEMBYTES);         // Grows down.  Software should set it.
   parameter [31:0] PROGADDR_RESET = 32'h0000_0000;
   parameter [31:0] PROGADDR_IRQ = 32'h0000_0000;

   wire                       reset_n; 
   wire                       mem_valid;
   wire                       mem_instr;
   wire [31:0]                mem_addr;
   wire [31:0]                mem_wdata;
   wire [31:0]                mem_rdata;
   wire [3:0]                 mem_wstrb;
   wire                       mem_ready;
   wire                       mem_inst;
   wire                       leds_sel;
   wire                       leds_ready;
   wire [31:0]                leds_data_o;
   wire                       sram_sel;
   wire                       sram_ready;
   wire [31:0]                sram_data_o;
   wire                       cdt_sel;
   wire                       cdt_ready;
   wire [31:0]                cdt_data_o;

   wire                       buttons_sel;
   wire                       buttons_ready;
   wire [31:0]                buttons_data_o;

   wire game_status_sel;
   wire game_state_sel;
   wire game_score_sel;
   wire game_high_score_sel;

   wire game_status_ready;
   wire game_state_ready;
   wire game_score_ready;
  // wire game_high_score_ready;

   wire [31:0]  game_state_data_o;
   wire [31:0]  game_status_data_o;
   wire [31:0]  game_score_data_o;
  // wire [31:0]  game_high_score_data_o;

   wire [2:0]   game_status;
   wire [13:0]  global_score;


   // Establish memory map for all slaves:
   //      SRAM          00000000 - 0001ffff
   //      LED           80000000             -> 8 bits 
   //      UART          80000008 - 8000000f  -> 64 bits
   //      CDT           80000010 - 80000014  -> 40 bits
   //   BUTTONS          80000020             -> 5 bits
   //   GAME_STATE       80000024             -> 3 bits
   //   GAME_STATUS      80000028             -> 3 bits
   //   GAME_SCORE       8000002C - 8000002D  -> 14 bits
   //   GAME_HIGH_SCORE  80000030 - 80000031  -> 14 bits


    assign sram_sel            = mem_valid && (mem_addr < MEMBYTES);
    assign leds_sel            = mem_valid && (mem_addr == 32'h80000000);
    assign cdt_sel             = mem_valid && (mem_addr == 32'h80000010);
    assign buttons_sel         = mem_valid && (mem_addr == 32'h80000020);
    assign game_state_sel      = mem_valid && (mem_addr == 32'h80000024);
    assign game_status_sel     = mem_valid && (mem_addr == 32'h80000028);
    assign game_score_sel      = mem_valid && (mem_addr == 32'h8000002C);
    assign game_high_score_sel = mem_valid && (mem_addr == 32'h80000030);

   // Core can proceed regardless of *which* slave was targetted and is now ready.
   assign mem_ready = mem_valid & (sram_ready | leds_ready  | cdt_ready  | buttons_ready | game_status_ready | game_state_ready | game_score_ready); // | game_high_score_ready);


   // Select which slave's output data is to be fed to core.
   assign mem_rdata = sram_sel ? sram_data_o :
                      leds_sel ? leds_data_o :
                      cdt_sel  ? cdt_data_o  :
                      buttons_sel ? buttons_data_o :
                      game_status_sel ? game_status_data_o : 
                      game_state_sel ? game_state_data_o : 
                      game_score_sel ? game_score_data_o : 
                      game_high_score_sel ? 32'h0 : 32'h0;


   assign leds =  ~buttons; // ~leds_data_o[5:0] | ~buttons; // Connect to the LEDs of the FPGA

   // LEDS READ AND WRITE 
   mem_read_write #(
        .DATA_SIZE(6)
    )
    soc_leds
   (
      .clk(clk),
      .reset_n(reset_n),
      .mem_sel(leds_sel),
      .mem_data_i(mem_wdata[5:0]),
      .we(mem_wstrb[0]),
      .mem_ready(leds_ready),
      .mem_data_o(leds_data_o)
   );

    // BUTTONS READ ONLY 
   mem_read_write #(
        .DATA_SIZE(5)
    )
    soc_buttons
   (
      .clk(clk),
      .reset_n(reset_n),
      .mem_sel(buttons_sel),
      .mem_data_i(buttons),
      .we(1'b1),
      .mem_ready(buttons_ready),
      .mem_data_o(buttons_data_o)
   );

   // GAME SCORE READ ONLY 

//   assign game_score_data_o = {{(18){1'b0}}, global_score};
//   assign game_score_ready = game_score_sel;

//     GAME HIGH SCORE WRITE ONLY 
//   mem_read_write #(
//        .DATA_SIZE(14)
//    )
//    soc_high_score
//   (
//      .clk(clk),
//      .reset_n(reset_n),
//      .mem_sel(game_high_score_sel),
//      .mem_data_i(mem_wdata[13:0]),
//      .we(|mem_wstrb[1:0]),
//      .mem_ready(game_high_score_ready),
//      .mem_data_o(game_high_score_data_o)
//   );

   // GAME STATUS READ ONLY 
   mem_read_write #(
        .DATA_SIZE(3)
    )
    soc_game_status
   (
      .clk(clk),
      .reset_n(reset_n),
      .mem_sel(game_status_sel),
      .mem_data_i(game_status),
      .we(1'b1),
      .mem_ready(game_status_ready),
      .mem_data_o(game_status_data_o)
   );

  // GAME STATE WRITE ONLY 
   mem_read_write #(
        .DATA_SIZE(3)
    )
    soc_game_state
   (
      .clk(clk),
      .reset_n(reset_n),
      .mem_sel(game_state_sel),
      .mem_data_i(mem_wdata[2:0]),
      .we(mem_wstrb[0]),
      .mem_ready(game_state_ready),
      .mem_data_o(game_state_data_o)
   );

    // --------------- LCD LED --------------------

    assign lcd_bl = 1'b1 ;

    wire clk_out; 

    pll_40m pll_40m_inst(
        .clkout (clk_out),  //output clkout
        .clkin  (clk)     //input clkin
    );

    parameter para = 8 ;

    wire [23:0] lcd_rgb  ;
    wire [23:0] lcd_data ;

    assign lcd_r[4:0] = lcd_rgb[4+ para*2:para*2];
    assign lcd_g[5:0] = lcd_rgb[5+ para*1:para*1];
    assign lcd_b[4:0] = lcd_rgb[4+ para*0:para*0];

    wire	[11:0]	lcd_xpos;		
    wire	[11:0]	lcd_ypos;		

    lcd_ctrl lcd_ctrl_inst (
        .clk        (clk_out)    ,      //lcd clock
        .rst_n      (reset_n)      ,      //sync reset
        .lcd_data   (lcd_data)   ,      //lcd data
        .lcd_clk    (lcd_clk)    ,      //lcd pixel clock
        .lcd_hs     (lcd_hsync)  ,	    //lcd horizontal sync
        .lcd_vs     (lcd_vsync)  ,	    //lcd vertical sync
        .lcd_de     (lcd_de)     ,	    //lcd display enable; 1:Display Enable Signal;0: Disable Ddsplay
        .lcd_rgb    (lcd_rgb)    ,      //lcd display data
        .lcd_xpos   (lcd_xpos)   ,      //lcd horizontal coordinate
        .lcd_ypos   (lcd_ypos)		    //lcd vertical coordinate
    );

    lcd_data_wrapper lcd_data_wrap_inst( 
        .clk(clk),	
        .rst_n(reset_n),	
        .buttons(buttons),	//lcd horizontal coordinate
        .lcd_xpos(lcd_xpos),	//lcd horizontal coordinate
        .lcd_ypos(lcd_ypos),	//lcd vertical coordinate

        .game_state(game_state_data_o[2:0]),	
      //  .high_score(game_high_score_data_o[13:0]),

        .game_status(game_status),	
        .score(global_score),	
	
        .lcd_data(lcd_data)	    //lcd data
    );


// ----------------- MEM and PROC stuffs ---------------------

   reset_control reset_controller
     (
      .clk(clk),
      .reset_button(reset_button),
      .reset_n(reset_n)
      );

   countdown_timer cdt
     (
      .clk(clk),
      .reset_n(reset_n),
      .cdt_sel(cdt_sel),
      .cdt_data_i(mem_wdata),
      .we(mem_wstrb),
      .cdt_ready(cdt_ready),
      .cdt_data_o(cdt_data_o)
      );

   sram #(.SRAM_ADDR_WIDTH(SRAM_ADDR_WIDTH)) memory
     (
      .clk(clk),
      .reset_n(reset_n),
      .sram_sel(sram_sel),
      .wstrb(mem_wstrb),
      .addr(mem_addr[SRAM_ADDR_WIDTH + 1:0]),
      .sram_data_i(mem_wdata),
      .sram_ready(sram_ready),
      .sram_data_o(sram_data_o)
      );

   picorv32
     #(
       .STACKADDR(STACKADDR),
       .PROGADDR_RESET(PROGADDR_RESET),
       .PROGADDR_IRQ(PROGADDR_IRQ),
       .BARREL_SHIFTER(BARREL_SHIFTER),
       .COMPRESSED_ISA(ENABLE_COMPRESSED),
       .ENABLE_MUL(ENABLE_MUL),
       .ENABLE_DIV(ENABLE_DIV),
       .ENABLE_FAST_MUL(ENABLE_FAST_MUL),
       .ENABLE_IRQ(1),
       .ENABLE_IRQ_QREGS(ENABLE_IRQ_QREGS)
       ) cpu
       (
        .clk         (clk),
        .resetn      (reset_n),
        .mem_valid   (mem_valid),
        .mem_instr   (mem_instr),
        .mem_ready   (mem_ready),
        .mem_addr    (mem_addr),
        .mem_wdata   (mem_wdata),
        .mem_wstrb   (mem_wstrb),
        .mem_rdata   (mem_rdata),
        .irq         ('b0)
        );
endmodule // top
