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

  reg [2:0] rMode;

  reg [13:0] rGen_Enb_sig;

  assign Ready = rReady;

  assign Mode  = rMode;

  always @(posedge Fg_Clk or negedge RESETn) begin : u_Begin_Ready
    if (!RESETn) begin  // RESETn toggle --> Begin_Ready == 1 always
      Begin_Ready = 1'b1;
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Ready
    if (!RESETn) begin
      rCnt_Ready <= 7'd0;
    end else begin
      if (Begin_Ready == 1'b1) begin
        rCnt_Ready <= (rCnt_Ready == 7'd79) ? rCnt_Ready <= 7'd0 : rCnt_Ready + 7'd1;
      end
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rReady
    if (!RESETn) begin
      rReady <= 1'b0;
    end else begin
      if (rCnt_Ready == 7'd79) begin
        rReady <= 1'b1;
        Begin_Ready <= 1'b0;
      end else begin
        rReady <= 1'b0;
      end
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rMode
    if (!RESETn) begin
      rMode <= 3'd0;
    end else begin
      if (IntBtn == 1'd1) begin
        rMode <= (rMode < 3'd4) ? rMode + 3'd1 : 3'd0;
      end
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rGen_Enb_sig
    if (!RESETn) begin
      rGen_Enb_sig <= 14'd1;
    end else begin
      case (rMode)
        3'd0: rGen_Enb_sig <= 14'd1;
        3'd1: rGen_Enb_sig <= 14'd10;
        3'd2: rGen_Enb_sig <= 14'd100;
        3'd3: rGen_Enb_sig <= 14'd1000;
        3'd4: rGen_Enb_sig <= 14'd10000;
        default: rGen_Enb_sig <= 14'd1;
      endcase
    end
  end

endmodule



