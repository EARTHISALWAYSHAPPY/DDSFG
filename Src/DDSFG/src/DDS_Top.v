//File name : DDS_Top.v
//Description : Top module for DDSFG.
//Company : KMITL
//Project : DDSFG
//------------------- 
//Version : 00.01              
//Date :  06.07.2025         
//Author : Kunanon Wanyen                
//Remark : Creation File
//------------------- 
module DDS_Top (
    input wire Ext_Clk,
    input wire Ext_RESETn,

    //tmp
    output wire wFg_Clk,
    output wire wDac_Clk
);
  wire wPll_RESET;
  wire wPll_clk;
  wire wPll_Lock;
  wire wFg_RESETn;

  PLL_Top m_pll (
      .clkin (Ext_Clk),
      .reset (1'b0), // Active High if use for sim 1'b0
      .clkout(wPll_Clk),
      .lock  (wPll_clk)
  );

  Clk_Div m_clk_div (
    .Pll_Clk(wPll_Clk),
    .RESETn(wFg_RESETn),
    .Fg_Clk(wFg_Clk),
    .Dac_Clk(wDac_Clks)
  );
endmodule
