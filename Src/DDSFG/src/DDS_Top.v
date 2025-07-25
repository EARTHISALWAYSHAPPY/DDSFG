//----------------------------------------//
// Filename     : DDS_Top.v
// Description  : Top module for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 06.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//
module DDS_Top (
    input  wire        Ext_Clk,
    input  wire        Ext_RESETn,
    input  wire        ExtBtn,
    input  wire        Ext_Rot_A,
    input  wire        Ext_Rot_B,
    input  wire        Ext_Btn_Rot_C,
    output wire        Dac_Clk,
    output wire [11:0] DDS_Out
);

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//
  wire        wPll_RESETn;
  wire        wPll_Clk;
  wire        wPll_Lock;
  wire        wFg_RESETn;
  wire        wFg_Clk;
  wire        wIntBtn;
  wire        wReady;
  wire        wEnable;
  wire [ 2:0] wMode;
  wire [31:0] wInit1;
  wire [31:0] wInit2;
  wire [31:0] wOut1;
  wire [31:0] wOut2;
  wire        wRot_C;
  wire [10:0] wAddress;
  wire        wFreqChng;

  //----------------------------------------//
  // Module Instantiation
  //----------------------------------------//

  // Reset Generator Module
  ResetGen_Module m_resetgen (
      .CLK      (Ext_Clk),
      .ExtRESETn(Ext_RESETn),
      .PllLocked(wPll_Lock),
      .PllRESETn(wPll_RESETn),
      .FgRESETn (wFg_RESETn)
  );

  // PLL Module
  Pll_Top m_pll (
      .clkin (Ext_Clk),
      .reset (~wPll_RESETn),  // Active High if use for sim 1'b0
      .clkout(wPll_Clk),
      .lock  (wPll_Lock)
  );

  // Clock Divider Module
  Clk_Div m_clk_div (
      .Pll_Clk(wPll_Clk),
      .RESETn (wFg_RESETn),
      .Fg_Clk (wFg_Clk),
      .Dac_Clk(Dac_Clk)
  );

  // Button Interface Module
  Btn_Interface m_btn_interface (
      .Fg_Clk(wFg_Clk),
      .RESETn(wFg_RESETn),
      .ExtBtn(ExtBtn),
      .IntBtn(wIntBtn)
  );

  // Ramp Control Module
  SampCtrl m_sampctrl (
      .Fg_Clk(wFg_Clk),
      .RESETn(wFg_RESETn),
      .IntBtn(wIntBtn),
      .Ready (wReady),
      .Enable(wEnable),
      .Mode  (wMode)
  );

  // Oscillator Module
  Osc_Top m_osc_top (
      .Fg_Clk(wFg_Clk),
      .RESETn(wFg_RESETn),
      .Enable(wEnable),
      .Ready(wReady),
      .Init1(wInit1),
      .Init2(wInit2),
      .FreqChng(wFreqChng),
      .Mode(wMode),  // for Zero_Cross Check origin point!! (Mode 0-3 [31:22]: 10 bits , Mode 4 [31:23] : 9 Bits)
      .Out1(wOut1),
      .Out2(wOut2)
  );

  // Interpolator Module 
  Interpolator m_interpolator (
      .Fg_Clk   (wFg_Clk),
      .RESETn   (wFg_RESETn),
      .Out1     (wOut1),
      .Out2     (wOut2),
      .Mode     (wMode),
      .Enable   (wEnable),
      .InterpOut(DDS_Out)      //<----
  );

  //  Button Interface For C Button in Rotary Encoder
  Btn_Interface m_btn_interface_rot_c (
      .Fg_Clk(wFg_Clk),
      .RESETn(wFg_RESETn),
      .ExtBtn(Ext_Btn_Rot_C),
      .IntBtn(wRot_C)
  );

  // Rotary Encoder Module
  Rotary_Encoder m_rotary_endcoder (
      .Fg_Clk  (wFg_Clk),
      .RESETn  (wFg_RESETn),
      .Rot_A   (Ext_Rot_A),
      .Rot_B   (Ext_Rot_B),
      .C       (wRot_C),
      .Mode    (wMode),
      .Address (wAddress),
      .FreqChng(wFreqChng)
  );

  //LookUp Table Module 
  Lookup_Table m_lookup_table (
      .Fg_Clk (wFg_Clk),
      .RESETn (wFg_RESETn),
      .Address(wAddress),
      //   .Out1   (wOut1),
      //   .Out2  (wOut2),
      .Sin1x  (wInit1),
      .Cos2x  (wInit2)
  );
  //----------------------------------------//
endmodule
