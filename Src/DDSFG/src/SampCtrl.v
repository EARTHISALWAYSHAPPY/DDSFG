//----------------------------------------//
// Filename     : SampCtrl.v
// Description  : SampCtrl module for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 12.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//
module SampCtrl (
    input  wire       Fg_Clk,
    input  wire       RESETn,
    input  wire       IntBtn,
    output wire       Ready,
    output wire       Enable,
    output wire [2:0] Mode
);
  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//
  reg Begin_Ready;
  reg rReady;
  reg [6:0] rCnt_Ready;

  reg [2:0] rMode;

  reg [13:0] rGen_signal;
  reg [13:0] rCnt_Enable;
  reg rEnable;

  reg rPulse_in;

  //----------------------------------------//
  // Output Declaration
  //----------------------------------------//
  assign Ready  = rReady;
  assign Mode   = rMode;
  assign Enable = rEnable;

  //----------------------------------------//
  // Process Declaration
  //----------------------------------------//

  // Initial Ready Process
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rBegin_Ready
    if (!RESETn) begin
      Begin_Ready <= 1'b0;
    end else begin
      Begin_Ready <= (rCnt_Ready == 7'd79) ? 1'b1 : Begin_Ready;
    end
  end

  // Ready Counter (0 -> 79)
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Ready
    if (!RESETn) begin
      rCnt_Ready <= 7'd0;
    end else begin
      if (Begin_Ready == 1'b0) begin
        rCnt_Ready <= (rCnt_Ready == 7'd79) ? 7'd0 : rCnt_Ready + 7'd1;
      end
    end
  end

  // Ready Signal 
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rReady
    if (!RESETn) begin
      rReady <= 1'b0;
    end else begin
      if (rCnt_Ready == 7'd79) begin
        rReady <= 1'b1;
      end else begin
        rReady <= 1'b0;
      end
    end
  end

  // Mode Ctrl
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rMode
    if (!RESETn) begin
      rMode <= 3'd0;
    end else begin
      if ((rEnable && rPulse_in) || (IntBtn && rMode == 3'd0)) begin
        rMode <= (rMode < 3'd4) ? rMode + 3'd1 : 3'd0;
      end
    end
  end

  // Signal Generator Mode
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rGen_signal
    if (!RESETn) begin
      rGen_signal <= 14'd1 - 1;
    end else begin
      case (rMode)
        3'd0: rGen_signal <= 14'd1 - 1;
        3'd1: rGen_signal <= 14'd10 - 1;
        3'd2: rGen_signal <= 14'd100 - 1;
        3'd3: rGen_signal <= 14'd1000 - 1;
        3'd4: rGen_signal <= 14'd10000 - 1;
        default: rGen_signal <= 14'd1 - 1;
      endcase
    end
  end

  // Counter for Enable
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Enable
    if (!RESETn) begin
      rCnt_Enable <= 14'd0;
    end else begin
      rCnt_Enable <= (rCnt_Enable < rGen_signal) ? rCnt_Enable + 14'd1 : 14'd0;
    end
  end

  // Enable Signal
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rEnable
    if (!RESETn) begin
      rEnable <= 1'b0;
    end else begin
      rEnable <= (rCnt_Enable == rGen_signal) ? 1'b1 : 1'b0;
    end
  end

  // Pulse Gen from Button
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rPulse_in
    if (!RESETn) begin
      rPulse_in <= 1'b0;
    end else if (rEnable) begin
      rPulse_in <= 1'b0;
    end else if (IntBtn) begin
      rPulse_in <= 1'b1;
    end else begin
      rPulse_in <= rPulse_in;
    end
  end

  //----------------------------------------//
endmodule
