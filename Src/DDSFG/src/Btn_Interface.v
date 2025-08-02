//----------------------------------------//
// Filename     : Btn_Interface.v
// Description  : Btn_Interface module for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 08.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//
module Btn_Interface (
    input  wire Fg_Clk,
    input  wire RESETn,
    input  wire ExtBtn,
    output wire IntBtn
);
  //----------------------------------------//
  // Constant Declaration
  //----------------------------------------//

  //`define SIM // Uncomment if Simulate
`ifdef SIM
  localparam delay = 22'd24 - 1;
`else
  localparam delay = 22'd2400000 - 1;
`endif

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//

  reg [24:0] rCnt;
  reg [ 2:0] rDout;

  //----------------------------------------//
  // Output Declaration
  //----------------------------------------//

  // Check negedge of Button
  assign IntBtn = (rDout[2] == 1'd1 && rDout[1] == 1'd0 && rCnt == delay) ? 1'd1 : 1'd0;

  //----------------------------------------//
  // Process Declaration
  //----------------------------------------//

  //debounce button
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt
    if (!RESETn) begin
      rCnt <= 25'd0;
    end else begin
      if (rCnt == delay && IntBtn) begin
        rCnt <= 25'd0;
      end else begin
        rCnt <= (rCnt < delay) ? rCnt + 25'd1 : rCnt;
      end
    end
  end

  // D filpflop for 2 flop Sync.
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rDout
    if (!RESETn) begin
      rDout <= 3'b111;
    end else begin
      rDout <= {rDout[1], rDout[0], ExtBtn};
    end
  end

  //----------------------------------------//
endmodule
