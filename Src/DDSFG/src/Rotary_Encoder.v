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
    output wire        Address,
    output wire [10:0] FreqChng
);

  //----------------------------------------//
  // Parameter Declaration
  //----------------------------------------//

  //`define SIM 
`ifdef SIM
  localparam Onehundred_ms = 22'd240 - 1;
`else
  localparam Onehundred_ms = 22'd2400000 - 1;
`endif

  localparam State_idle = 3'd0;
  localparam State_CW = 3'd1;
  localparam State_CCW = 3'd2;

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//

  wire        wRot_C;

  reg  [ 2:0] rFlop_Rot_A;
  reg  [ 2:0] rFlop_Rot_B;

  wire        A_Fall;
  wire        B_Fall;
  wire        Rot_C;

  reg  [21:0] rCnt_Delay;
  reg         rDelay;

  reg  [10:0] rCnt_Rot;
  reg  [ 1:0] rMode_step;
  reg  [10:0] rStep;

  reg  [ 1:0] State;
  reg         CW;
  reg         CCW;

  //----------------------------------------//
  // Assignments
  //----------------------------------------//

  assign A_Fall = (rFlop_Rot_A[2] == 1'b1 && rFlop_Rot_A[1] == 1'b0) ? 1'b1 : 1'b0;
  assign B_Fall = (rFlop_Rot_B[2] == 1'b1 && rFlop_Rot_B[1] == 1'b0) ? 1'b1 : 1'b0;
  assign Rot_C  = wRot_C;

  //----------------------------------------//
  // Submodule Instantiation
  //----------------------------------------//

  Btn_Interface_Rot_C m_btn_interface_rot_c (
      .Fg_Clk(Fg_Clk),
      .RESETn(RESETn),
      .ExtBtn(C),
      .IntBtn(wRot_C)
  );

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
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rMode_Step
    if (!RESETn) begin
      rMode_step <= 2'd0;
    end else begin
      if (Rot_C) begin
        rMode_step <= (rMode_step < 2'd2) ? rMode_step + 2'd1 : 2'd0;
      end
    end
  end

  // Step of Counting
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rStep
    if (!RESETn) begin
      rStep <= 7'd0;
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
  always @(posedge Fg_Clk or negedge RESETn) begin : u_State
    if (!RESETn) begin
      State <= State_idle;  // <-- begin start idle state
      CW <= 1'b0;
      CCW <= 1'b0;
    end else begin
      case (State)
        State_idle: begin
          CW <= 1'b0;
          CCW <= 1'b0;
          State <= (A_Fall) ? State_CCW : (B_Fall) ? State_CW : State_idle;
        end
        State_CW: begin
          if (A_Fall) begin
            CW <= 1'b1;
            State <= State_idle;
          end
        end
        State_CCW: begin
          if (B_Fall) begin
            CCW   <= 1'b1;
            State <= State_idle;
          end
        end
      endcase
    end
  end

  //up/down counting
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Rot
    if (!RESETn) begin
      rCnt_Rot <= 11'd0;
    end else begin
      if (CW) begin
        rCnt_Rot <= (rCnt_Rot + rStep >= 11'd1800) ? 11'd1800 : rCnt_Rot + rStep;
      end else if (CCW) begin
        rCnt_Rot <= (rCnt_Rot < rStep) ? 11'd0 : rCnt_Rot - rStep;
      end
    end
  end

  //----------------------------------------//
endmodule
