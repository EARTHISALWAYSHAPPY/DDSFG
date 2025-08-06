//----------------------------------------//
// Filename     : Clk_Div.v
// Description  : Clk_Div module for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 06.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//

module Clk_Div (
    input  wire Pll_Clk,
    input  wire RESETn,
    output wire Fg_Clk,
    output wire Dac_Clk
);

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//

  reg rFg_Clk;
  reg rDac_Clk;

  //----------------------------------------//
  // Output Declaration
  //----------------------------------------//

  assign Fg_Clk  = rFg_Clk;
  assign Dac_Clk = rDac_Clk;

  //----------------------------------------//
  // Process Declaration
  //----------------------------------------//

  // Toggle Fg_Clk (rising edge of Pll_Clk)
  always @(posedge Pll_Clk or negedge RESETn) begin : u_rFg_Clk
    if (!RESETn) begin
      rFg_Clk <= 1'd0;
    end else begin
      rFg_Clk <= ~rFg_Clk;
    end
  end

  // Toggle Dac_Clk (falling edge of Pll_Clk)
  always @(negedge Pll_Clk or negedge RESETn) begin : u_rDac_Clk
    if (!RESETn) begin
      rDac_Clk <= 1'd0;
    end else begin
      rDac_Clk <= ~rDac_Clk;
    end
  end

  //----------------------------------------//
endmodule
