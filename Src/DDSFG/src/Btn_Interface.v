//File name : Btn_Interface.v
//Description : Btn_Interface module for DDSFG.
//Company : KMITL
//Project : DDSFG
//------------------- 
//Version : 00.01              
//Date :  08.07.2025         
//Author : Kunanon Wanyen                
//Remark : Creation File
module Btn_Interface (
    input  wire Fg_CLK,
    input  wire RESETn,
    input  wire ExtBtn,
    output wire IntBtn
);

  reg [2:0] rDout;

  assign IntBtn = (rDout[2] == 1'd1 && rDout[1] == 1'd0) ? 1'd1 : 1'd0;

  always @(posedge Fg_CLK or negedge RESETn) begin : u_rDout
    if (RESETn == 1'd0) begin
      rDout <= 3'b111;
    end else begin
      rDout <= {rDout[1], rDout[0], ExtBtn};
    end
  end

endmodule
