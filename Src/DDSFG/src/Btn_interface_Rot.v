//----------------------------------------//
// Filename     : Btn_Interface_Rot_c.v
// Description  : Btn_Interface module for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 15.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//
module Btn_Interface_Rot_C (
    input  wire Fg_Clk,
    input  wire RESETn,
    input  wire ExtBtn,
    output wire IntBtn
);
  
  wire wIntBtn;
  reg [2:0] rDout;

  assign wIntBtn = (rDout[2] == 1'd1 && rDout[1] == 1'd0) ? 1'd1 : 1'd0;
  assign IntBtn  = wIntBtn;

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rDout
    if (!RESETn) begin
      rDout <= 3'b111;
    end else begin
      rDout <= {rDout[1], rDout[0], ExtBtn};
    end
  end

endmodule
