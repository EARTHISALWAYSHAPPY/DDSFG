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
  wire [2:0] wMode;

  reg Ext_RESETn;  //wRESETn
  reg rExtBtn;

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

  initial begin  // มั่วค่ามาเอาไวเทส only
    Ext_RESETn = 1'b1;
    #10000;
    Ext_RESETn = 1'b0;
    #5;
    Ext_RESETn = 1'b1;
    #1000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;

    Ext_RESETn = 1'b0;
    #5;
    Ext_RESETn = 1'b1;
    #10000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #500;
    rExtBtn = 1'b1;
    #2400000;
  end


endmodule
