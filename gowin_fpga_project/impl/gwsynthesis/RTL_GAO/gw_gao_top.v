module gw_gao(
    \game_score_data_o[31] ,
    \game_score_data_o[30] ,
    \game_score_data_o[29] ,
    \game_score_data_o[28] ,
    \game_score_data_o[27] ,
    \game_score_data_o[26] ,
    \game_score_data_o[25] ,
    \game_score_data_o[24] ,
    \game_score_data_o[23] ,
    \game_score_data_o[22] ,
    \game_score_data_o[21] ,
    \game_score_data_o[20] ,
    \game_score_data_o[19] ,
    \game_score_data_o[18] ,
    \game_score_data_o[17] ,
    \game_score_data_o[16] ,
    \game_score_data_o[15] ,
    \game_score_data_o[14] ,
    \game_score_data_o[13] ,
    \game_score_data_o[12] ,
    \game_score_data_o[11] ,
    \game_score_data_o[10] ,
    \game_score_data_o[9] ,
    \game_score_data_o[8] ,
    \game_score_data_o[7] ,
    \game_score_data_o[6] ,
    \game_score_data_o[5] ,
    \game_score_data_o[4] ,
    \game_score_data_o[3] ,
    \game_score_data_o[2] ,
    \game_score_data_o[1] ,
    \game_score_data_o[0] ,
    game_score_sel,
    \lcd_data_wrap_inst/lcd_data_inst/score[13] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[12] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[11] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[10] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[9] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[8] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[7] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[6] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[5] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[4] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[3] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[2] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[1] ,
    \lcd_data_wrap_inst/lcd_data_inst/score[0] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[13] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[12] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[11] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[10] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[9] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[8] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[7] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[6] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[5] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[4] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[3] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[2] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[1] ,
    \lcd_data_wrap_inst/lcd_data_inst/high_score[0] ,
    \lcd_data_wrap_inst/lcd_data_inst/show_game_over ,
    \lcd_data_wrap_inst/game_over_finished ,
    \lcd_data_wrap_inst/is_game_over ,
    \soc_high_score/mem_data_i[13] ,
    \soc_high_score/mem_data_i[12] ,
    \soc_high_score/mem_data_i[11] ,
    \soc_high_score/mem_data_i[10] ,
    \soc_high_score/mem_data_i[9] ,
    \soc_high_score/mem_data_i[8] ,
    \soc_high_score/mem_data_i[7] ,
    \soc_high_score/mem_data_i[6] ,
    \soc_high_score/mem_data_i[5] ,
    \soc_high_score/mem_data_i[4] ,
    \soc_high_score/mem_data_i[3] ,
    \soc_high_score/mem_data_i[2] ,
    \soc_high_score/mem_data_i[1] ,
    \soc_high_score/mem_data_i[0] ,
    \soc_high_score/mem_data_o[31] ,
    \soc_high_score/mem_data_o[30] ,
    \soc_high_score/mem_data_o[29] ,
    \soc_high_score/mem_data_o[28] ,
    \soc_high_score/mem_data_o[27] ,
    \soc_high_score/mem_data_o[26] ,
    \soc_high_score/mem_data_o[25] ,
    \soc_high_score/mem_data_o[24] ,
    \soc_high_score/mem_data_o[23] ,
    \soc_high_score/mem_data_o[22] ,
    \soc_high_score/mem_data_o[21] ,
    \soc_high_score/mem_data_o[20] ,
    \soc_high_score/mem_data_o[19] ,
    \soc_high_score/mem_data_o[18] ,
    \soc_high_score/mem_data_o[17] ,
    \soc_high_score/mem_data_o[16] ,
    \soc_high_score/mem_data_o[15] ,
    \soc_high_score/mem_data_o[14] ,
    \soc_high_score/mem_data_o[13] ,
    \soc_high_score/mem_data_o[12] ,
    \soc_high_score/mem_data_o[11] ,
    \soc_high_score/mem_data_o[10] ,
    \soc_high_score/mem_data_o[9] ,
    \soc_high_score/mem_data_o[8] ,
    \soc_high_score/mem_data_o[7] ,
    \soc_high_score/mem_data_o[6] ,
    \soc_high_score/mem_data_o[5] ,
    \soc_high_score/mem_data_o[4] ,
    \soc_high_score/mem_data_o[3] ,
    \soc_high_score/mem_data_o[2] ,
    \soc_high_score/mem_data_o[1] ,
    \soc_high_score/mem_data_o[0] ,
    \soc_high_score/data[13] ,
    \soc_high_score/data[12] ,
    \soc_high_score/data[11] ,
    \soc_high_score/data[10] ,
    \soc_high_score/data[9] ,
    \soc_high_score/data[8] ,
    \soc_high_score/data[7] ,
    \soc_high_score/data[6] ,
    \soc_high_score/data[5] ,
    \soc_high_score/data[4] ,
    \soc_high_score/data[3] ,
    \soc_high_score/data[2] ,
    \soc_high_score/data[1] ,
    \soc_high_score/data[0] ,
    \soc_high_score/mem_sel ,
    \soc_high_score/we ,
    \soc_high_score/mem_ready ,
    \soc_score/mem_sel ,
    lcd_clk,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input \game_score_data_o[31] ;
input \game_score_data_o[30] ;
input \game_score_data_o[29] ;
input \game_score_data_o[28] ;
input \game_score_data_o[27] ;
input \game_score_data_o[26] ;
input \game_score_data_o[25] ;
input \game_score_data_o[24] ;
input \game_score_data_o[23] ;
input \game_score_data_o[22] ;
input \game_score_data_o[21] ;
input \game_score_data_o[20] ;
input \game_score_data_o[19] ;
input \game_score_data_o[18] ;
input \game_score_data_o[17] ;
input \game_score_data_o[16] ;
input \game_score_data_o[15] ;
input \game_score_data_o[14] ;
input \game_score_data_o[13] ;
input \game_score_data_o[12] ;
input \game_score_data_o[11] ;
input \game_score_data_o[10] ;
input \game_score_data_o[9] ;
input \game_score_data_o[8] ;
input \game_score_data_o[7] ;
input \game_score_data_o[6] ;
input \game_score_data_o[5] ;
input \game_score_data_o[4] ;
input \game_score_data_o[3] ;
input \game_score_data_o[2] ;
input \game_score_data_o[1] ;
input \game_score_data_o[0] ;
input game_score_sel;
input \lcd_data_wrap_inst/lcd_data_inst/score[13] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[12] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[11] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[10] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[9] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[8] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[7] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[6] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[5] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[4] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[3] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[2] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[1] ;
input \lcd_data_wrap_inst/lcd_data_inst/score[0] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[13] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[12] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[11] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[10] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[9] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[8] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[7] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[6] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[5] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[4] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[3] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[2] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[1] ;
input \lcd_data_wrap_inst/lcd_data_inst/high_score[0] ;
input \lcd_data_wrap_inst/lcd_data_inst/show_game_over ;
input \lcd_data_wrap_inst/game_over_finished ;
input \lcd_data_wrap_inst/is_game_over ;
input \soc_high_score/mem_data_i[13] ;
input \soc_high_score/mem_data_i[12] ;
input \soc_high_score/mem_data_i[11] ;
input \soc_high_score/mem_data_i[10] ;
input \soc_high_score/mem_data_i[9] ;
input \soc_high_score/mem_data_i[8] ;
input \soc_high_score/mem_data_i[7] ;
input \soc_high_score/mem_data_i[6] ;
input \soc_high_score/mem_data_i[5] ;
input \soc_high_score/mem_data_i[4] ;
input \soc_high_score/mem_data_i[3] ;
input \soc_high_score/mem_data_i[2] ;
input \soc_high_score/mem_data_i[1] ;
input \soc_high_score/mem_data_i[0] ;
input \soc_high_score/mem_data_o[31] ;
input \soc_high_score/mem_data_o[30] ;
input \soc_high_score/mem_data_o[29] ;
input \soc_high_score/mem_data_o[28] ;
input \soc_high_score/mem_data_o[27] ;
input \soc_high_score/mem_data_o[26] ;
input \soc_high_score/mem_data_o[25] ;
input \soc_high_score/mem_data_o[24] ;
input \soc_high_score/mem_data_o[23] ;
input \soc_high_score/mem_data_o[22] ;
input \soc_high_score/mem_data_o[21] ;
input \soc_high_score/mem_data_o[20] ;
input \soc_high_score/mem_data_o[19] ;
input \soc_high_score/mem_data_o[18] ;
input \soc_high_score/mem_data_o[17] ;
input \soc_high_score/mem_data_o[16] ;
input \soc_high_score/mem_data_o[15] ;
input \soc_high_score/mem_data_o[14] ;
input \soc_high_score/mem_data_o[13] ;
input \soc_high_score/mem_data_o[12] ;
input \soc_high_score/mem_data_o[11] ;
input \soc_high_score/mem_data_o[10] ;
input \soc_high_score/mem_data_o[9] ;
input \soc_high_score/mem_data_o[8] ;
input \soc_high_score/mem_data_o[7] ;
input \soc_high_score/mem_data_o[6] ;
input \soc_high_score/mem_data_o[5] ;
input \soc_high_score/mem_data_o[4] ;
input \soc_high_score/mem_data_o[3] ;
input \soc_high_score/mem_data_o[2] ;
input \soc_high_score/mem_data_o[1] ;
input \soc_high_score/mem_data_o[0] ;
input \soc_high_score/data[13] ;
input \soc_high_score/data[12] ;
input \soc_high_score/data[11] ;
input \soc_high_score/data[10] ;
input \soc_high_score/data[9] ;
input \soc_high_score/data[8] ;
input \soc_high_score/data[7] ;
input \soc_high_score/data[6] ;
input \soc_high_score/data[5] ;
input \soc_high_score/data[4] ;
input \soc_high_score/data[3] ;
input \soc_high_score/data[2] ;
input \soc_high_score/data[1] ;
input \soc_high_score/data[0] ;
input \soc_high_score/mem_sel ;
input \soc_high_score/we ;
input \soc_high_score/mem_ready ;
input \soc_score/mem_sel ;
input lcd_clk;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire \game_score_data_o[31] ;
wire \game_score_data_o[30] ;
wire \game_score_data_o[29] ;
wire \game_score_data_o[28] ;
wire \game_score_data_o[27] ;
wire \game_score_data_o[26] ;
wire \game_score_data_o[25] ;
wire \game_score_data_o[24] ;
wire \game_score_data_o[23] ;
wire \game_score_data_o[22] ;
wire \game_score_data_o[21] ;
wire \game_score_data_o[20] ;
wire \game_score_data_o[19] ;
wire \game_score_data_o[18] ;
wire \game_score_data_o[17] ;
wire \game_score_data_o[16] ;
wire \game_score_data_o[15] ;
wire \game_score_data_o[14] ;
wire \game_score_data_o[13] ;
wire \game_score_data_o[12] ;
wire \game_score_data_o[11] ;
wire \game_score_data_o[10] ;
wire \game_score_data_o[9] ;
wire \game_score_data_o[8] ;
wire \game_score_data_o[7] ;
wire \game_score_data_o[6] ;
wire \game_score_data_o[5] ;
wire \game_score_data_o[4] ;
wire \game_score_data_o[3] ;
wire \game_score_data_o[2] ;
wire \game_score_data_o[1] ;
wire \game_score_data_o[0] ;
wire game_score_sel;
wire \lcd_data_wrap_inst/lcd_data_inst/score[13] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[12] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[11] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[10] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[9] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[8] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[7] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[6] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[5] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[4] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[3] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[2] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[1] ;
wire \lcd_data_wrap_inst/lcd_data_inst/score[0] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[13] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[12] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[11] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[10] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[9] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[8] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[7] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[6] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[5] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[4] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[3] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[2] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[1] ;
wire \lcd_data_wrap_inst/lcd_data_inst/high_score[0] ;
wire \lcd_data_wrap_inst/lcd_data_inst/show_game_over ;
wire \lcd_data_wrap_inst/game_over_finished ;
wire \lcd_data_wrap_inst/is_game_over ;
wire \soc_high_score/mem_data_i[13] ;
wire \soc_high_score/mem_data_i[12] ;
wire \soc_high_score/mem_data_i[11] ;
wire \soc_high_score/mem_data_i[10] ;
wire \soc_high_score/mem_data_i[9] ;
wire \soc_high_score/mem_data_i[8] ;
wire \soc_high_score/mem_data_i[7] ;
wire \soc_high_score/mem_data_i[6] ;
wire \soc_high_score/mem_data_i[5] ;
wire \soc_high_score/mem_data_i[4] ;
wire \soc_high_score/mem_data_i[3] ;
wire \soc_high_score/mem_data_i[2] ;
wire \soc_high_score/mem_data_i[1] ;
wire \soc_high_score/mem_data_i[0] ;
wire \soc_high_score/mem_data_o[31] ;
wire \soc_high_score/mem_data_o[30] ;
wire \soc_high_score/mem_data_o[29] ;
wire \soc_high_score/mem_data_o[28] ;
wire \soc_high_score/mem_data_o[27] ;
wire \soc_high_score/mem_data_o[26] ;
wire \soc_high_score/mem_data_o[25] ;
wire \soc_high_score/mem_data_o[24] ;
wire \soc_high_score/mem_data_o[23] ;
wire \soc_high_score/mem_data_o[22] ;
wire \soc_high_score/mem_data_o[21] ;
wire \soc_high_score/mem_data_o[20] ;
wire \soc_high_score/mem_data_o[19] ;
wire \soc_high_score/mem_data_o[18] ;
wire \soc_high_score/mem_data_o[17] ;
wire \soc_high_score/mem_data_o[16] ;
wire \soc_high_score/mem_data_o[15] ;
wire \soc_high_score/mem_data_o[14] ;
wire \soc_high_score/mem_data_o[13] ;
wire \soc_high_score/mem_data_o[12] ;
wire \soc_high_score/mem_data_o[11] ;
wire \soc_high_score/mem_data_o[10] ;
wire \soc_high_score/mem_data_o[9] ;
wire \soc_high_score/mem_data_o[8] ;
wire \soc_high_score/mem_data_o[7] ;
wire \soc_high_score/mem_data_o[6] ;
wire \soc_high_score/mem_data_o[5] ;
wire \soc_high_score/mem_data_o[4] ;
wire \soc_high_score/mem_data_o[3] ;
wire \soc_high_score/mem_data_o[2] ;
wire \soc_high_score/mem_data_o[1] ;
wire \soc_high_score/mem_data_o[0] ;
wire \soc_high_score/data[13] ;
wire \soc_high_score/data[12] ;
wire \soc_high_score/data[11] ;
wire \soc_high_score/data[10] ;
wire \soc_high_score/data[9] ;
wire \soc_high_score/data[8] ;
wire \soc_high_score/data[7] ;
wire \soc_high_score/data[6] ;
wire \soc_high_score/data[5] ;
wire \soc_high_score/data[4] ;
wire \soc_high_score/data[3] ;
wire \soc_high_score/data[2] ;
wire \soc_high_score/data[1] ;
wire \soc_high_score/data[0] ;
wire \soc_high_score/mem_sel ;
wire \soc_high_score/we ;
wire \soc_high_score/mem_ready ;
wire \soc_score/mem_sel ;
wire lcd_clk;
wire tms_pad_i;
wire tck_pad_i;
wire tdi_pad_i;
wire tdo_pad_o;
wire tms_i_c;
wire tck_i_c;
wire tdi_i_c;
wire tdo_o_c;
wire [9:0] control0;
wire gao_jtag_tck;
wire gao_jtag_reset;
wire run_test_idle_er1;
wire run_test_idle_er2;
wire shift_dr_capture_dr;
wire update_dr;
wire pause_dr;
wire enable_er1;
wire enable_er2;
wire gao_jtag_tdi;
wire tdo_er1;

IBUF tms_ibuf (
    .I(tms_pad_i),
    .O(tms_i_c)
);

IBUF tck_ibuf (
    .I(tck_pad_i),
    .O(tck_i_c)
);

IBUF tdi_ibuf (
    .I(tdi_pad_i),
    .O(tdi_i_c)
);

OBUF tdo_obuf (
    .I(tdo_o_c),
    .O(tdo_pad_o)
);

GW_JTAG  u_gw_jtag(
    .tms_pad_i(tms_i_c),
    .tck_pad_i(tck_i_c),
    .tdi_pad_i(tdi_i_c),
    .tdo_pad_o(tdo_o_c),
    .tck_o(gao_jtag_tck),
    .test_logic_reset_o(gao_jtag_reset),
    .run_test_idle_er1_o(run_test_idle_er1),
    .run_test_idle_er2_o(run_test_idle_er2),
    .shift_dr_capture_dr_o(shift_dr_capture_dr),
    .update_dr_o(update_dr),
    .pause_dr_o(pause_dr),
    .enable_er1_o(enable_er1),
    .enable_er2_o(enable_er2),
    .tdi_o(gao_jtag_tdi),
    .tdo_er1_i(tdo_er1),
    .tdo_er2_i(1'b0)
);

gw_con_top  u_icon_top(
    .tck_i(gao_jtag_tck),
    .tdi_i(gao_jtag_tdi),
    .tdo_o(tdo_er1),
    .rst_i(gao_jtag_reset),
    .control0(control0[9:0]),
    .enable_i(enable_er1),
    .shift_dr_capture_dr_i(shift_dr_capture_dr),
    .update_dr_i(update_dr)
);

ao_top_0  u_la0_top(
    .control(control0[9:0]),
    .trig0_i(\soc_score/mem_sel ),
    .data_i({\game_score_data_o[31] ,\game_score_data_o[30] ,\game_score_data_o[29] ,\game_score_data_o[28] ,\game_score_data_o[27] ,\game_score_data_o[26] ,\game_score_data_o[25] ,\game_score_data_o[24] ,\game_score_data_o[23] ,\game_score_data_o[22] ,\game_score_data_o[21] ,\game_score_data_o[20] ,\game_score_data_o[19] ,\game_score_data_o[18] ,\game_score_data_o[17] ,\game_score_data_o[16] ,\game_score_data_o[15] ,\game_score_data_o[14] ,\game_score_data_o[13] ,\game_score_data_o[12] ,\game_score_data_o[11] ,\game_score_data_o[10] ,\game_score_data_o[9] ,\game_score_data_o[8] ,\game_score_data_o[7] ,\game_score_data_o[6] ,\game_score_data_o[5] ,\game_score_data_o[4] ,\game_score_data_o[3] ,\game_score_data_o[2] ,\game_score_data_o[1] ,\game_score_data_o[0] ,game_score_sel,\lcd_data_wrap_inst/lcd_data_inst/score[13] ,\lcd_data_wrap_inst/lcd_data_inst/score[12] ,\lcd_data_wrap_inst/lcd_data_inst/score[11] ,\lcd_data_wrap_inst/lcd_data_inst/score[10] ,\lcd_data_wrap_inst/lcd_data_inst/score[9] ,\lcd_data_wrap_inst/lcd_data_inst/score[8] ,\lcd_data_wrap_inst/lcd_data_inst/score[7] ,\lcd_data_wrap_inst/lcd_data_inst/score[6] ,\lcd_data_wrap_inst/lcd_data_inst/score[5] ,\lcd_data_wrap_inst/lcd_data_inst/score[4] ,\lcd_data_wrap_inst/lcd_data_inst/score[3] ,\lcd_data_wrap_inst/lcd_data_inst/score[2] ,\lcd_data_wrap_inst/lcd_data_inst/score[1] ,\lcd_data_wrap_inst/lcd_data_inst/score[0] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[13] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[12] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[11] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[10] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[9] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[8] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[7] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[6] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[5] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[4] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[3] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[2] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[1] ,\lcd_data_wrap_inst/lcd_data_inst/high_score[0] ,\lcd_data_wrap_inst/lcd_data_inst/show_game_over ,\lcd_data_wrap_inst/game_over_finished ,\lcd_data_wrap_inst/is_game_over ,\soc_high_score/mem_data_i[13] ,\soc_high_score/mem_data_i[12] ,\soc_high_score/mem_data_i[11] ,\soc_high_score/mem_data_i[10] ,\soc_high_score/mem_data_i[9] ,\soc_high_score/mem_data_i[8] ,\soc_high_score/mem_data_i[7] ,\soc_high_score/mem_data_i[6] ,\soc_high_score/mem_data_i[5] ,\soc_high_score/mem_data_i[4] ,\soc_high_score/mem_data_i[3] ,\soc_high_score/mem_data_i[2] ,\soc_high_score/mem_data_i[1] ,\soc_high_score/mem_data_i[0] ,\soc_high_score/mem_data_o[31] ,\soc_high_score/mem_data_o[30] ,\soc_high_score/mem_data_o[29] ,\soc_high_score/mem_data_o[28] ,\soc_high_score/mem_data_o[27] ,\soc_high_score/mem_data_o[26] ,\soc_high_score/mem_data_o[25] ,\soc_high_score/mem_data_o[24] ,\soc_high_score/mem_data_o[23] ,\soc_high_score/mem_data_o[22] ,\soc_high_score/mem_data_o[21] ,\soc_high_score/mem_data_o[20] ,\soc_high_score/mem_data_o[19] ,\soc_high_score/mem_data_o[18] ,\soc_high_score/mem_data_o[17] ,\soc_high_score/mem_data_o[16] ,\soc_high_score/mem_data_o[15] ,\soc_high_score/mem_data_o[14] ,\soc_high_score/mem_data_o[13] ,\soc_high_score/mem_data_o[12] ,\soc_high_score/mem_data_o[11] ,\soc_high_score/mem_data_o[10] ,\soc_high_score/mem_data_o[9] ,\soc_high_score/mem_data_o[8] ,\soc_high_score/mem_data_o[7] ,\soc_high_score/mem_data_o[6] ,\soc_high_score/mem_data_o[5] ,\soc_high_score/mem_data_o[4] ,\soc_high_score/mem_data_o[3] ,\soc_high_score/mem_data_o[2] ,\soc_high_score/mem_data_o[1] ,\soc_high_score/mem_data_o[0] ,\soc_high_score/data[13] ,\soc_high_score/data[12] ,\soc_high_score/data[11] ,\soc_high_score/data[10] ,\soc_high_score/data[9] ,\soc_high_score/data[8] ,\soc_high_score/data[7] ,\soc_high_score/data[6] ,\soc_high_score/data[5] ,\soc_high_score/data[4] ,\soc_high_score/data[3] ,\soc_high_score/data[2] ,\soc_high_score/data[1] ,\soc_high_score/data[0] ,\soc_high_score/mem_sel ,\soc_high_score/we ,\soc_high_score/mem_ready }),
    .clk_i(lcd_clk)
);

endmodule
