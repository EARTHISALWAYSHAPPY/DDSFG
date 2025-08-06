//----------------------------------------//
// Filename     : Lookup_Table.v
// Description  : Lookup Table for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 19.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//

module Lookup_Table (
    input  wire        Fg_Clk,
    input  wire        RESETn,
    input  wire [10:0] Address,
    // input  wire [31:0] Out1,
    // input  wire [31:0] Out2,
    output wire [31:0] Sin1x,
    output wire [31:0] Cos2x
);

  //----------------------------------------//
  // Internal Signal
  //----------------------------------------//

  reg  [47:0] Coefficient;
  wire [47:0] wCoefficient;

  //----------------------------------------//
  // Output Assignment
  //----------------------------------------//

  assign Sin1x = {4'b0000, Coefficient[47:24], 4'b0000};
  assign Cos2x = {6'b001111, Coefficient[23:0], 2'b00};

  //----------------------------------------//
  // ROM Coefficient Instantiation
  //----------------------------------------//

  romcoef_module m_romcoef (
      .dout (wCoefficient),  // output [47:0] dout
      .clk  (Fg_Clk),        // input clk
      .oce  (1'b1),          // input oce (1 = pipeline)
      .ce   (1'b1),          // input ce  (1 = awaken chip)
      .reset(~RESETn),       // input reset
      .ad   (Address)        // input [10:0] ad
  );

  //----------------------------------------//
  // Coefficient Register Update
  //----------------------------------------//
  
  always @(posedge Fg_Clk or negedge RESETn) begin
    if (!RESETn) Coefficient <= 48'd0;
    else Coefficient <= wCoefficient;
  end

endmodule
