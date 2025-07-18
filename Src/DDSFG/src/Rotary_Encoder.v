module Rotary_Encoder (
    input wire Fg_Clk,
    input wire RESETn,
    input wire Rot_A,
    input wire Rot_B,
    input wire C,
    output wire Address,
    output wire [10:0] FreqChng
);

  // `define SIM 
`ifdef SIM
  localparam Onehundred_ms = 22'd240 - 1;
`else
  localparam Onehundred_ms = 22'd2400000 - 1;
`endif
  //localparam Onehundred_ms = 13'd2400 - 1;

  wire wRot_C;

  reg [2:0] rFlop_Rot_A;
  reg [2:0] rFlop_Rot_B;

  reg rRot_A;
  reg rRot_B;

  reg Rot_C;

  reg [21:0] rCnt_Delay;  // 100 ms = 2400000 tick
  reg rDelay;

  reg [10:0] rCnt_Rot;

  reg [1:0] rMode_step;
  reg [6:0] rStep;

  assign rRot_A = (rFlop_Rot_A[2] == 1'd1 && rFlop_Rot_A[1] == 1'd0) ? 1'd1 : 1'd0;
  assign rRot_B = (rFlop_Rot_B[2] == 1'd1 && rFlop_Rot_B[1] == 1'd0) ? 1'd1 : 1'd0;

  assign Rot_C  = wRot_C;

  // For Btn Rot_C
  Btn_Interface_Rot_C m_btn_unterface_rot_c (
      .Fg_Clk(Fg_Clk),
      .RESETn(RESETn),
      .ExtBtn(C),
      .IntBtn(wRot_C)
  );

  //2-Flop Sync. Rot-A
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rFlop_Rot_A
    if (!RESETn) begin
      rFlop_Rot_A <= 3'b111;
    end else begin
      rFlop_Rot_A <= {rFlop_Rot_A[1], rFlop_Rot_A[0], Rot_A};
    end
  end

  //2-Flop Sync. Rot-B
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rFlop_Rot_B
    if (!RESETn) begin
      rFlop_Rot_B <= 3'b111;
    end else begin
      rFlop_Rot_B <= {rFlop_Rot_B[1], rFlop_Rot_B[0], Rot_B};
    end
  end

  //Counter Delay
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Delay
    if (!RESETn) begin
      rCnt_Delay <= 13'd0;
    end else begin
      rCnt_Delay <= (rCnt_Delay < Onehundred_ms) ? rCnt_Delay + 13'd1 : 13'd0;
    end
  end

  //Toggle Delay Signal
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rDelay
    if (!RESETn) begin
      rDelay <= 1'b0;
    end else begin
      rDelay <= (rCnt_Delay == Onehundred_ms) ? 1'b1 : 1'b0;
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rMode_Step
    if (!RESETn) begin
      rMode_step <= 2'd0;
    end else begin
      if (Rot_C) begin
        rMode_step <= (rMode_step < 2'd2) ? rMode_step + 2'd1 : 2'd0;
      end
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rStep
    if (!RESETn) begin
      rStep <= 7'd0;
    end else begin
      case (rMode_step)
        2'd0: rStep <= 7'd1;
        2'd1: rStep <= 7'd10;
        2'd2: rStep <= 7'd100;
        default: rStep <= 7'd1;
      endcase
    end
  end


endmodule

