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
    output wire        FreqChng,
    output wire [ 1:0] Mode_Step  // for debug
);

  //----------------------------------------//
  // Parameter Declaration
  //----------------------------------------//

  //`define SIM // Uncomment if Simulate
`ifdef SIM
  localparam Onehundred_ms = 22'd240 - 1;
`else
  localparam Onehundred_ms = 22'd2400000 - 1;  // 100 ms
`endif

  localparam Step_Min = 11'd0;
  localparam Step_Min_Mode4 = 11'd800;
  localparam Step_Max = 11'd1800;

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//

  reg [ 2:0] rFlop_Rot_A;
  reg [ 2:0] rFlop_Rot_B;
  reg        A_Fall;
  reg        B_Fall;
  reg        Steady_A;
  reg        Steady_B;
  reg [21:0] rCnt_Delay;
  reg        rDelay;
  reg [10:0] rCnt_Rot;
  reg [ 1:0] rMode_step;
  reg [10:0] rStep;
  reg [ 3:0] State;
  reg [10:0] rAddress;
  reg        rFreqChng;
  reg [13:0] rCnt_Debounce_A;
  reg [13:0] rCnt_Debounce_B;
  reg [13:0] rCnt_Debounce_State;

  reg [ 1:0] Step_Enable;
  reg        Direction;
  reg        Enable;

  //----------------------------------------//
  // Assignments
  //----------------------------------------//

  assign Mode_Step = rMode_step;
  assign Address   = rAddress;  //<------------ wait LUT
  assign FreqChng  = rFreqChng;

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

  // Combination 
  always @(*) begin
    Enable <= rFlop_Rot_A[1] ^ rFlop_Rot_A[2] ^ rFlop_Rot_B[1] ^ rFlop_Rot_B[2];
    Direction <= rFlop_Rot_A[2] ^ rFlop_Rot_B[1];
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
      rStep <= 11'd1;
    end else begin
      case (rMode_step)
        2'd0:    rStep <= 11'd1;
        2'd1:    rStep <= 11'd10;
        2'd2:    rStep <= 11'd100;
        default: rStep <= 11'd1;
      endcase
    end
  end

  //Count Step_Enable
  always @(posedge Fg_Clk or negedge RESETn) begin : u_Step_Enable
    if (!RESETn) begin
      Step_Enable <= 2'd0;
    end else begin
      Step_Enable <= (Enable) ? Step_Enable + 2'd1 : Step_Enable;
    end
  end

  // rCnt_ Rot from XOR logic
  always @(posedge Fg_Clk or negedge RESETn) begin
    if (!RESETn) begin
      rCnt_Rot <= 11'd0;
    end else if (Step_Enable == 2'd3) begin
      if (Direction) begin
        rCnt_Rot <= (rCnt_Rot + rStep >= Step_Max) ? Step_Max : rCnt_Rot + rStep;
      end else begin
        rCnt_Rot <= (Mode != 3'd4 && rCnt_Rot < rStep) ?  Step_Min : 
                    (Mode == 3'd4 && rCnt_Rot <= Step_Min_Mode4) ?  Step_Min_Mode4 : 
                    rCnt_Rot - rStep;
      end
    end
  end

  // add rCnt_Rot to rAddress
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rAddress
    if (!RESETn) begin
      rAddress <= 11'd0;
    end else begin
      if (rDelay) begin
        //rAddress <= rCnt_Rot;
        rAddress <= (Mode == 3'd4 && rCnt_Rot < Step_Min_Mode4) ? Step_Min_Mode4 : rCnt_Rot;
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
Mode 3 : 100  - 1K   Hz
Mode 4 : 50   - 100   Hz (50 is address 800)
*/
