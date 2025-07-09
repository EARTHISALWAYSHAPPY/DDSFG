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

  localparam delay = 25'd2400 - 1;

  wire wIntBtn;

  reg [24:0] rCnt;
  reg [2:0] rDout;

  assign wIntBtn = (rDout[2] == 1'd1 && rDout[1] == 1'd0 && rCnt == 25'd0) ? 1'd1 : 1'd0;
  assign IntBtn  = wIntBtn;

  always @(posedge Fg_CLK or negedge RESETn) begin : u_rCnt
    if (!RESETn) begin
      rCnt <= 25'd0;
    end else begin
      if (rCnt == 25'd0) begin
        rCnt <= (wIntBtn == 1'b1) ? 25'd1 : 25'd0;
      end else begin
        rCnt <= (rCnt < delay) ? rCnt + 25'd1 : 25'd0;
      end
    end
  end

  always @(posedge Fg_CLK or negedge RESETn) begin : u_rDout
    if (!RESETn) begin
      rDout <= 3'b111;
    end else begin
      rDout <= {rDout[1], rDout[0], ExtBtn};
    end
  end

endmodule


// temp
// if (rCnt != 25'd0 && wIntBtn == 1'd0) begin
//   rCnt <= rCnt + 25'd1;
// end
// if (rCnt == delay) begin
//   rCnt <= 25'd0;
// end
// if (rCnt == 25'd0 && wIntBtn == 1'd1) begin
//   rCnt <= 25'd1;
// end
