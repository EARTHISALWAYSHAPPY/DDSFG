//----------------------------------------//
// Filename     : Oscillator.v
// Description  : Oscillator module for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 08.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//
module Osc_Top (
    input wire Fg_Clk,
    input wire RESETn,
    input wire Enable,
    input wire Ready,
    input wire [31:0] Init1,  //sin(b)
    input wire [31:0] Init2,  //2cos(b)
    output wire [31:0] Out1,
    output wire [31:0] Out2
);

  reg [31:0] a;
  reg [31:0] b;
  reg [63:0] c;
  reg [31:0] Out1_a;
  reg [31:0] Out;
  reg [31:0] rOut1;
  reg [31:0] rOut2;


  assign Out1 = rOut1;  //seq
  assign Out2 = rOut2;  //seq

  always @(*) begin : u_Out1_a
    Out1_a <= c[60:29];
  end

  always @(*) begin : u_Out
    Out <= Out1_a - Out2;
  end

  always @(*) begin : for_combination_from_Formula
    c <= $signed(a) * $signed(Out1);
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rOut1
    if (!RESETn) begin
      rOut1 <= 32'd0;
    end else if (Ready) begin
      rOut1 <= Init1;
    end else if (Enable) begin
      rOut1 <= Out;
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_rOut2
    if (!RESETn) begin
      rOut2 <= 32'd0;
    end else if (Ready) begin
      rOut2 <= 32'd0;
    end else if (Enable) begin
      rOut2 <= Out1;
    end
  end

  always @(posedge Fg_Clk or negedge RESETn) begin : u_a  // a = 2cos(B)
    if (!RESETn) begin
      a <= 31'd0;
    end else if (Ready) begin
      a <= Init2;
    end
  end

endmodule
