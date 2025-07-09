//File name : SampCtrl.v
//Description : SampCtrl module for DDSFG.
//Company : KMITL
//Project : DDSFG
//------------------- 
//Version : 00.01              
//Date :  09.07.2025         
//Author : Kunanon Wanyen                
//Remark : Creation File
//------------------- 
module SampCtrl (
    input  wire Fg_Clk,
    input  wire RESETn,
    input  wire IntBtn,
    output wire Ready,
    output wire Enable,
    output wire Mode
);

  reg Begin_Ready;
  reg rReady;
  reg [6:0] rCnt_Ready;

  assign Ready = rReady;

  always @(posedge Fg_Clk or negedge RESETn) begin : u_Begin_Ready
    if (!RESETn) begin  // RESETn toggle --> Begin_Ready == 1 always
      Begin_Ready = 1'b1;
    end else begin
      Begin_Ready <= (rCnt_Ready == 7'd79) ? 1'b0 : 1'b1;
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Ready
    if (!RESETn) begin
      rCnt_Ready <= 7'd0;
    end else begin
      if (Begin_Ready == 1'b1) begin
        rCnt_Ready <= (rCnt_Ready == 7'd79) ? rCnt_Ready <= 7'd0 : rCnt_Ready + 7'd1;
      end else begin

      end
    end
  end


  always @(posedge Fg_Clk or negedge RESETn) begin : u_rReady
    if (!RESETn) begin
      rReady <= 1'b0;
    end else begin
      rReady <= (rCnt_Ready == 7'd79) ? 1'd1 : 1'd0;
    end
  end

endmodule



