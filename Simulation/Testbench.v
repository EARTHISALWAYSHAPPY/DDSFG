`timescale 1ns / 1ps
module Testbench ();

  wire wExt_Clk;
  wire wPll_RESETn;
  wire wFg_RESETn;
  wire wPll_Lock;
  wire wPll_Clk;
  wire wFg_Clk;
  wire wDac_Clk;
  wire wIntBtn;
  wire wReady;
  wire wEnable;
  wire wMode;

  reg  Ext_RESETn;  //wRESETn
  reg  rExtBtn;

  initial begin
    Ext_RESETn = 1'b1;
    #440000;
    Ext_RESETn = 1'b0;
    #240;
    Ext_RESETn = 1'b1;
    #440;
    rExtBtn = 1'b1;
    #240000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #24000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #100000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #24000;
  end

  RCC m_rcc (.Ext_Clk(wExt_Clk));  // for sim only gen CLK

  ResetGen_Module m_resetgen (
      .CLK(wExt_Clk),
      .ExtRESETn(Ext_RESETn),
      .PllLocked(wPll_Lock),
      .PllRESETn(wPll_RESETn),
      .FgRESETn(wFg_RESETn)
  );

  Pll_Top m_pll (
      .clkin (wExt_Clk),
      .reset (~wPll_RESETn),
      .clkout(wPll_Clk),
      .lock  (wPll_Lock)
  );

  Clk_Div m_clk_div (
      .Pll_Clk(wPll_Clk),
      .RESETn (wFg_RESETn),
      .Fg_Clk (wFg_Clk),
      .Dac_Clk(wDac_Clk)
  );

  Btn_Interface m_btn_interface (
      .Fg_CLK(wFg_Clk),
      .RESETn(Ext_RESETn),
      .ExtBtn(rExtBtn),
      .IntBtn(wIntBtn)
  );
  SampCtrl m_sampctrl (
      .Fg_Clk(wFg_Clk),
      .RESETn(wFg_RESETn),
      .IntBtn(wIntBtn),
      .Ready (wReady),
      .Enable(wEnable),
      .Mode  (wMode)
  );

endmodule
