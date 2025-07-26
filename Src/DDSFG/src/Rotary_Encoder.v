//----------------------------------------//
// Filename     : Rotary_Encoder.v
// Description  : Rotary Encoder Module for DDSFG
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 15.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//
module Rotary_Encoder (
    input  wire        Fg_Clk,
    input  wire        RESETn,
    input  wire        Rot_A,
    input  wire        Rot_B,
    input  wire        C,
    input  wire [ 2:0] Mode,
    output wire [10:0] Address,
    output wire        FreqChng
);

  //----------------------------------------//
  // Parameter Declaration
  //----------------------------------------//

  `define SIM // Uncomment if Simulate
`ifdef SIM
  localparam Onehundred_ms = 22'd24 - 1;
`else
  localparam Onehundred_ms = 22'd2400000 - 1;
`endif

  localparam State_idle = 3'd0;
  localparam State_CW = 3'd1;
  localparam State_CCW = 3'd2;

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//

  reg  [ 2:0] rFlop_Rot_A;
  reg  [ 2:0] rFlop_Rot_B;
  wire        A_Fall;
  wire        B_Fall;
  reg  [21:0] rCnt_Delay;
  reg         rDelay;
  reg  [10:0] rCnt_Rot;
  reg  [ 1:0] rMode_step;
  reg  [ 6:0] rStep;
  reg  [ 1:0] State;
  reg         CW;
  reg         CCW;
  reg  [10:0] rAddress;
  reg         rFreqChng;

  //----------------------------------------//
  // Assignments
  //----------------------------------------//

  assign A_Fall   = (rFlop_Rot_A[2] == 1'b1 && rFlop_Rot_A[1] == 1'b0) ? 1'b1 : 1'b0;
  assign B_Fall   = (rFlop_Rot_B[2] == 1'b1 && rFlop_Rot_B[1] == 1'b0) ? 1'b1 : 1'b0;
  assign Address  = rAddress;  //<------------ wait LUT
  assign FreqChng = rFreqChng;

  //----------------------------------------//
  // Submodule Instantiation
  //----------------------------------------//


  //----------------------------------------//
  // Sequential Logic
  //----------------------------------------//

  // Sync Rot_A with 2-flop
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rFlop_Rot_A
    if (!RESETn) begin
      rFlop_Rot_A <= 3'b111;
    end else begin
      rFlop_Rot_A <= {rFlop_Rot_A[1], rFlop_Rot_A[0], Rot_A};
    end
  end

  // Sync Rot_B with 2-flop
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rFlop_Rot_B
    if (!RESETn) begin
      rFlop_Rot_B <= 3'b111;
    end else begin
      rFlop_Rot_B <= {rFlop_Rot_B[1], rFlop_Rot_B[0], Rot_B};
    end
  end

  // Delay Counter (100 ms)
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Delay
    if (!RESETn) begin
      rCnt_Delay <= 22'd0;
    end else begin
      rCnt_Delay <= (rCnt_Delay < Onehundred_ms) ? rCnt_Delay + 22'd1 : 22'd0;
    end
  end

  // Toggle delay pulse every 100 ms
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rDelay
    if (!RESETn) begin
      rDelay <= 1'b0;
    end else begin
      rDelay <= (rCnt_Delay == Onehundred_ms) ? 1'b1 : 1'b0;
    end
  end

  // Mode selector by button press (C)
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rMode_Step_and_rStep
    if (!RESETn) begin
      rMode_step <= 2'd0;
    end else begin
      if (C) begin
        rMode_step <= (rMode_step < 2'd2) ? rMode_step + 2'd1 : 2'd0;
      end
    end
  end

  // Step of Counting
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rStep
    if (!RESETn) begin
      rStep <= 7'd1;
    end else begin
      case (rMode_step)
        2'd0:    rStep <= 7'd1;
        2'd1:    rStep <= 7'd10;
        2'd2:    rStep <= 7'd100;
        default: rStep <= 7'd1;
      endcase
    end
  end

  //State machine for up/down
  always @(posedge Fg_Clk or negedge RESETn) begin : u_State_and_rCnt_Rot
    if (!RESETn) begin
      State <= State_idle;  // <-- begin start idle state
      rCnt_Rot <= 11'd0;
      CW <= 1'b0;
      CCW <= 1'b0;
    end else begin
      case (State)
        State_idle: begin
          State <= (A_Fall) ? State_CCW : (B_Fall) ? State_CW : State_idle;
          CW <= 1'b0;
          CCW <= 1'b0;
        end
        State_CW: begin
          CW <= 1'b1;
          State <= (A_Fall) ? State_idle : State;
        end
        State_CCW: begin
          CCW   <= 1'b1;
          State <= (B_Fall) ? State_idle : State;
        end
      endcase
      if (CW) begin
        rCnt_Rot <= (rCnt_Rot + rStep >= 11'd1800) ? 11'd1800 : rCnt_Rot + rStep;
      end else if (CCW) begin
        rCnt_Rot <= (Mode < 3'd4 && rCnt_Rot < rStep) ?  11'd0 :
                    (Mode == 3'd4 && rCnt_Rot <= 11'd800) ?  11'd800 : rCnt_Rot - rStep;
      end
    end
  end

  // add rCnt_Rot to rAddress
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rAddress
    if (!RESETn) begin
      rAddress <= 11'd0;
    end else begin
      if (rDelay) begin
        //rAddress <= (Mode == 3'd4 && rAddress <= 11'd800) ? 11'd800 : rCnt_Rot;
        rAddress <= rCnt_Rot;
      end
    end
  end

  // Compare to toggle rFreqChng
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rFreqChng
    if (!RESETn) begin
      rFreqChng <= 1'b0;
    end else begin
      rFreqChng <= ((rAddress != rCnt_Rot) && (rDelay)) ? 1'b1 : 1'b0;
    end
  end

  //----------------------------------------//
endmodule

/*
// Note...........
Mode 0 : 100k - 1000k Hz
Mode 1 : 10k  - 100k  Hz
Mode 2 : 1k   - 10k   Hz
Mode 3 : 1k   - 100   Hz
Mode 4 : 50   - 100   Hz (50 is address 800)
*/
