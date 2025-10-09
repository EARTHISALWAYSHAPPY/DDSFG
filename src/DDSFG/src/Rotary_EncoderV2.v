//----------------------------------------//
// Filename     : Rotary_Encoder.v
// Description  : Rotary Encoder Module for DDSFG
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 05.08.2025
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
  //`define SIM
`ifdef SIM
  localparam Onehundred_ms = 22'd240 - 1;
  localparam Zerodotone_ms = 12'd24 - 1;
  localparam Twentyfivehundred_ms = 23'd120 - 1;
`else
  localparam Onehundred_ms = 22'd2400000 - 1;  // 100 ms
  localparam Zerodotone_ms = 12'd2400 - 1;
  localparam Twentyfivehundred_ms = 23'd5000000 - 1;
`endif

  localparam Step_Min = 11'd0;
  localparam Step_Min_Mode4 = 11'd800;
  localparam Step_Max = 11'd1800 - 1; // dont use 1800 because mode 1 not fine zero cross

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//

  reg [ 2:0] rFlop_Rot_A;
  reg [ 2:0] rFlop_Rot_B;
  reg [21:0] rCnt_Delay;
  reg        rDelay;
  reg [10:0] rCnt_Rot;
  reg [ 1:0] rMode_step;
  reg [10:0] rStep;
  reg [10:0] rAddress;
  reg        rFreqChng;

  reg [ 1:0] Step_Enable;
  reg        Direction;
  reg        Enable;

  reg [22:0] rDebounce_Mode_steps;
  reg [11:0] rDebounce_Step;
  //----------------------------------------//
  // Assignments
  //----------------------------------------//

  assign Mode_Step = rMode_step;
  assign Address   = rAddress;
  assign FreqChng  = rFreqChng;

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

  // Combination Logic
  always @(*) begin : u_Enable_Direction
    Enable    = rFlop_Rot_A[1] ^ rFlop_Rot_A[2] ^ rFlop_Rot_B[1] ^ rFlop_Rot_B[2];

    //Direction = rFlop_Rot_A[1] ^ rFlop_Rot_B[2]; 
    Direction = rFlop_Rot_A[2] ^ rFlop_Rot_B[1]; // I think for EC11B15242AE
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

  // Debounce Mode Step
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rDebounce_Mode_steps
    if (!RESETn) begin
      rDebounce_Mode_steps <= 23'd0;
    end else begin
      if (C && rDebounce_Mode_steps == Twentyfivehundred_ms) begin
        rDebounce_Mode_steps <= 23'd0;
      end else begin
        rDebounce_Mode_steps <= (rDebounce_Mode_steps < Twentyfivehundred_ms) ? rDebounce_Mode_steps + 23'd1 : rDebounce_Mode_steps;
      end
    end
  end

  // Mode selector by button press (C)
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rMode_Step_and_rStep
    if (!RESETn) begin
      rMode_step <= 2'd0;
    end else begin
      if (C && rDebounce_Mode_steps == Twentyfivehundred_ms) begin
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

  // Debounce Step
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rDebounce_Step
    if (!RESETn) begin
      rDebounce_Step <= 21'd0;
    end else begin
      if (Step_Enable == 2'd3 && rDebounce_Step == Zerodotone_ms) begin
        rDebounce_Step <= 21'd0;
      end else begin
        rDebounce_Step <= (rDebounce_Step < Zerodotone_ms) ? rDebounce_Step + 12'd1 : rDebounce_Step;
      end
    end
  end

  //Step_Enable + rCnt_Rot
  always @(posedge Fg_Clk or negedge RESETn) begin : u_Step_Enable_rCnt_Rot
    if (!RESETn) begin
      Step_Enable <= 2'd0;
      rCnt_Rot <= 11'd0;
    end else if (Enable) begin
      if (Step_Enable == 2'd3 && rDebounce_Step == Zerodotone_ms) begin
        Step_Enable <= 2'd0;
        if (Direction) begin
          rCnt_Rot <= (rCnt_Rot + rStep >= Step_Max) ? Step_Max : rCnt_Rot + rStep;
        end else begin
          rCnt_Rot <= (Mode != 3'd4 && rCnt_Rot < rStep) ?  Step_Min : 
                      (Mode == 3'd4 && rCnt_Rot <= Step_Min_Mode4) ?  Step_Min_Mode4 : 
                      rCnt_Rot - rStep;
        end
      end else begin
        Step_Enable <= Step_Enable + 2'd1;
      end
    end
  end

  // Update Address every 100ms
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rAddress
    if (!RESETn) begin
      rAddress <= 11'd0;
    end else begin
      if (rDelay) begin
        rAddress <= (Mode == 3'd4 && rCnt_Rot < Step_Min_Mode4) ? Step_Min_Mode4 : rCnt_Rot;
      end
    end
  end

  // Toggle FreqChng when address changes
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rFreqChng
    if (!RESETn) begin
      rFreqChng <= 1'b0;
    end else begin
      rFreqChng <= ((rAddress != rCnt_Rot) && (rDelay)) ? 1'b1 : 1'b0;
    end
  end

endmodule

/*
// Note...........
Mode 0 : 100k - 1000k Hz
Mode 1 : 10k  - 100k  Hz
Mode 2 : 1k   - 10k   Hz
Mode 3 : 100  - 1K   Hz
Mode 4 : 50   - 100  Hz (50 is address 800)
*/
