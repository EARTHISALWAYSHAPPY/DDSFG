module gw_gao(
    wFg_Clk,
    ExtBtn,
    \LED_Mode[2] ,
    \LED_Mode[1] ,
    \LED_Mode[0] ,
    Ext_Rot_A,
    Ext_Rot_B,
    Ext_Btn_Rot_C,
    \LED_Mode_Step[1] ,
    \LED_Mode_Step[0] ,
    \m_rotary_endcoder/Address[10] ,
    \m_rotary_endcoder/Address[9] ,
    \m_rotary_endcoder/Address[8] ,
    \m_rotary_endcoder/Address[7] ,
    \m_rotary_endcoder/Address[6] ,
    \m_rotary_endcoder/Address[5] ,
    \m_rotary_endcoder/Address[4] ,
    \m_rotary_endcoder/Address[3] ,
    \m_rotary_endcoder/Address[2] ,
    \m_rotary_endcoder/Address[1] ,
    \m_rotary_endcoder/Address[0] ,
    \DDS_Out[11] ,
    \DDS_Out[10] ,
    \DDS_Out[9] ,
    \DDS_Out[8] ,
    \DDS_Out[7] ,
    \DDS_Out[6] ,
    \DDS_Out[5] ,
    \DDS_Out[4] ,
    \DDS_Out[3] ,
    \DDS_Out[2] ,
    \DDS_Out[1] ,
    \DDS_Out[0] ,
    \m_osc_top/Fg_Clk ,
    tms_pad_i,
    tck_pad_i,
    tdi_pad_i,
    tdo_pad_o
);

input wFg_Clk;
input ExtBtn;
input \LED_Mode[2] ;
input \LED_Mode[1] ;
input \LED_Mode[0] ;
input Ext_Rot_A;
input Ext_Rot_B;
input Ext_Btn_Rot_C;
input \LED_Mode_Step[1] ;
input \LED_Mode_Step[0] ;
input \m_rotary_endcoder/Address[10] ;
input \m_rotary_endcoder/Address[9] ;
input \m_rotary_endcoder/Address[8] ;
input \m_rotary_endcoder/Address[7] ;
input \m_rotary_endcoder/Address[6] ;
input \m_rotary_endcoder/Address[5] ;
input \m_rotary_endcoder/Address[4] ;
input \m_rotary_endcoder/Address[3] ;
input \m_rotary_endcoder/Address[2] ;
input \m_rotary_endcoder/Address[1] ;
input \m_rotary_endcoder/Address[0] ;
input \DDS_Out[11] ;
input \DDS_Out[10] ;
input \DDS_Out[9] ;
input \DDS_Out[8] ;
input \DDS_Out[7] ;
input \DDS_Out[6] ;
input \DDS_Out[5] ;
input \DDS_Out[4] ;
input \DDS_Out[3] ;
input \DDS_Out[2] ;
input \DDS_Out[1] ;
input \DDS_Out[0] ;
input \m_osc_top/Fg_Clk ;
input tms_pad_i;
input tck_pad_i;
input tdi_pad_i;
output tdo_pad_o;

wire wFg_Clk;
wire ExtBtn;
wire \LED_Mode[2] ;
wire \LED_Mode[1] ;
wire \LED_Mode[0] ;
wire Ext_Rot_A;
wire Ext_Rot_B;
wire Ext_Btn_Rot_C;
wire \LED_Mode_Step[1] ;
wire \LED_Mode_Step[0] ;
wire \m_rotary_endcoder/Address[10] ;
wire \m_rotary_endcoder/Address[9] ;
wire \m_rotary_endcoder/Address[8] ;
wire \m_rotary_endcoder/Address[7] ;
wire \m_rotary_endcoder/Address[6] ;
wire \m_rotary_endcoder/Address[5] ;
wire \m_rotary_endcoder/Address[4] ;
wire \m_rotary_endcoder/Address[3] ;
wire \m_rotary_endcoder/Address[2] ;
wire \m_rotary_endcoder/Address[1] ;
wire \m_rotary_endcoder/Address[0] ;
wire \DDS_Out[11] ;
wire \DDS_Out[10] ;
wire \DDS_Out[9] ;
wire \DDS_Out[8] ;
wire \DDS_Out[7] ;
wire \DDS_Out[6] ;
wire \DDS_Out[5] ;
wire \DDS_Out[4] ;
wire \DDS_Out[3] ;
wire \DDS_Out[2] ;
wire \DDS_Out[1] ;
wire \DDS_Out[0] ;
wire \m_osc_top/Fg_Clk ;
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

ao_top u_ao_top(
    .control(control0[9:0]),
    .data_i({wFg_Clk,ExtBtn,\LED_Mode[2] ,\LED_Mode[1] ,\LED_Mode[0] ,Ext_Rot_A,Ext_Rot_B,Ext_Btn_Rot_C,\LED_Mode_Step[1] ,\LED_Mode_Step[0] ,\m_rotary_endcoder/Address[10] ,\m_rotary_endcoder/Address[9] ,\m_rotary_endcoder/Address[8] ,\m_rotary_endcoder/Address[7] ,\m_rotary_endcoder/Address[6] ,\m_rotary_endcoder/Address[5] ,\m_rotary_endcoder/Address[4] ,\m_rotary_endcoder/Address[3] ,\m_rotary_endcoder/Address[2] ,\m_rotary_endcoder/Address[1] ,\m_rotary_endcoder/Address[0] ,\DDS_Out[11] ,\DDS_Out[10] ,\DDS_Out[9] ,\DDS_Out[8] ,\DDS_Out[7] ,\DDS_Out[6] ,\DDS_Out[5] ,\DDS_Out[4] ,\DDS_Out[3] ,\DDS_Out[2] ,\DDS_Out[1] ,\DDS_Out[0] }),
    .clk_i(\m_osc_top/Fg_Clk )
);

endmodule
