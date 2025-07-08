`timescale 1ns / 1ps
module Testbench ();

  wire wExt_Clk;
  wire wPll_Clk;
  wire wPll_Lock;
  wire wFg_Clk;
  wire wDac_Clk;
  wire wIntBtn;

  reg  rRESETn;  //wRESETn
  reg  rExtBtn;

  initial begin
    rRESETn = 1'b0;
    #240;
    rRESETn = 1'b1;
    #440;

    rExtBtn = 1'b1;
    #2400000;
    rExtBtn = 1'b0;
    #5000;
    rExtBtn = 1'b1;
    #24000;
    rExtBtn = 1'b0;
    #5000;
    rExtBtn = 1'b1;
    #24000;
    rExtBtn = 1'b0;
    #5000;
    rExtBtn = 1'b1;
  #240000;
    rExtBtn = 1'b0;
    #5000;
    rExtBtn = 1'b1;
    #24000;

  end

  RCC m_rcc (.Ext_Clk(wExt_Clk));

  Pll_Top m_pll (
      .clkin (wExt_Clk),
      .reset (~rRESETn),
      .clkout(wPll_Clk),
      .lock  (wPll_Lock)
  );

  Clk_Div m_clk_div (
      .Pll_Clk(wPll_Clk),
      .RESETn (rRESETn),
      .Fg_Clk (wFg_Clk),
      .Dac_Clk(wDac_Clk)
  );

  Btn_Interface m_btn_interface (
      .Fg_CLK(wFg_Clk),
      .RESETn(rRESETn),
      .ExtBtn(rExtBtn),
      .IntBtn(wIntBtn)
  );

endmodule
