//----------------------------------------//
// Filename     : SampCtrl.v
// Description  : SampCtrl module for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 09.07.2025
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

  // Initial Ready Process Triggered by Reset
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rBegin_Ready
    if (!RESETn) Begin_Ready <= 1'b1;
    else Begin_Ready <= Begin_Ready;
  end

  // Ready Counter (0 → 79)
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Ready
    if (!RESETn) rCnt_Ready <= 7'd0;
    else if (Begin_Ready) rCnt_Ready <= (rCnt_Ready == 7'd79) ? 7'd0 : rCnt_Ready + 7'd1;
  end

  // Ready Signal Control
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rReady
    if (!RESETn) rReady <= 1'b0;
    else if (rCnt_Ready == 7'd79) begin
      rReady <= 1'b1;
      Begin_Ready <= 1'b0;
    end else rReady <= 1'b0;
  end

  // Mode Control by Button
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rMode
    if (!RESETn) rMode <= 3'd0;
    else if ((rEnable && rPulse_in) || (IntBtn && rMode == 3'd0))
      rMode <= (rMode < 3'd4) ? rMode + 3'd1 : 3'd0;
  end

  // Signal Generator Threshold by Mode
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rGen_signal
    if (!RESETn) rGen_signal <= 14'd0;
    else begin
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

  // Counter for Enable timing
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Enable
    if (!RESETn) rCnt_Enable <= 14'd0;
    else rCnt_Enable <= (rCnt_Enable < rGen_signal) ? rCnt_Enable + 14'd1 : 14'd0;
  end

  // Enable Signal when Counter matches threshold
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rEnable
    if (!RESETn) rEnable <= 1'b0;
    else rEnable <= (rCnt_Enable == rGen_signal) ? 1'b1 : 1'b0;
  end

  // Pulse Generator from Button
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rPulse_in
    if (!RESETn) rPulse_in <= 1'b0;
    else if (rEnable) rPulse_in <= 1'b0;
    else if (IntBtn) rPulse_in <= 1'b1;
    else rPulse_in <= rPulse_in;
  end

  //----------------------------------------//
endmodule
