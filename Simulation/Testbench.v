`timescale 1ns / 1ps
module Testbench (
    output wire wFg_Clk,
    output wire wDac_Clk
);


  wire wExt_Clk;
  wire wPll_Clk;
  wire wPll_Lock;


  reg  rRESETn;

  initial begin
    rRESETn = 1'b0;
    #100;
    rRESETn = 1'b1;
  end

  RCC m_rcc (.Ext_Clk(wExt_Clk));

  Pll_Top m_pll (
      .clkin (wExt_Clk),
      .reset (1'b0),
      .clkout(wPll_Clk),
      .lock  (wPll_Lock)
  );

  Clk_Div m_clk_div (
      .Pll_Clk(wPll_Clk),
      .RESETn (rRESETn),
      .Fg_Clk (wFg_Clk),
      .Dac_Clk(wDac_Clk)
  );

endmodule
