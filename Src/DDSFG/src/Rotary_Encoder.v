module Rotary_Encoder (
    input wire Fg_Clk,
    input wire RESETn,
    input wire Rot_A,
    input wire Rot_B,
    input wire C,
    output wire Address,
    output wire [10:0] FreqChng
);

`ifdef SIM
  parameter Onehundred_ms = 13'd2400 - 1;
`else
  parameter Onehundred_ms = 13'd2400000 - 1;
`endif
  //localparam Onehundred_ms = 13'd2400 - 1;

  wire wRot_C;
  reg [2:0] rFlop_Rot_A;
  reg [2:0] rFlop_Rot_B;
  reg rRot_A;
  reg rRot_B;
  reg rCnt_Rot;
  reg Rot_C;
  reg [12:0] rCnt_Delay;  // 100 ms = 2400000 tick
  reg rDelay;

  assign Rot_C = wRot_C;

  Btn_Interface_Rot_C m_btn_unterface_rot_c (  // For Btn Rot_C
      .Fg_Clk(Fg_Clk),
      .RESETn(RESETn),
      .ExtBtn(C),
      .IntBtn(wRot_C)
  );

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rCnt_Delay
    if (!RESETn) begin
      rCnt_Delay <= 13'd0;
    end else begin
      rCnt_Delay <= (rCnt_Delay < Onehundred_ms) ? rCnt_Delay + 13'd1 : 13'd0;
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rDelay
    if (!RESETn) begin
      rDelay <= 1'b0;
    end else begin
      rDelay <= (rCnt_Delay == Onehundred_ms) ? 1'b1 : 1'b0;
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rFlop_Rot_A
    if (!RESETn) begin
      rFlop_Rot_A <= 3'b111;
    end else begin
      rFlop_Rot_A <= {rFlop_Rot_A[1], rFlop_Rot_A[0], Rot_A};
    end
  end

endmodule
