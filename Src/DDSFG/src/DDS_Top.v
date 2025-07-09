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
    input wire Ext_RESETn
);

  wire wPll_RESET;
  wire wPll_Clk;
  wire wPll_Lock;
  wire wFg_RESETn;
  wire wFg_Clk;
  wire wDac_Clk;

  ResetGen_Module m_resetgen (
      .CLK(Ext_Clk),
      .ExtRESETn(Ext_RESETn),
      .PllLocked(wPll_Lock),
      .PllRESETn(wPll_RESET),
      .FgRESETn(wFg_RESETn)
  );

  Pll_Top m_pll (
      .clkin (Ext_Clk),
      .reset (~wPll_RESETn),  // Active High if use for sim 1'b0
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
      .RESETn(wFg_RESETn),
      .ExtBtn(rExtBtn),
      .IntBtn(wIntBtn)
  );
endmodule
