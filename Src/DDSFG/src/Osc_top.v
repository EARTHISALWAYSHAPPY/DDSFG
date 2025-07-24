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
    input  wire        Fg_Clk,
    input  wire        RESETn,
    input  wire        Enable,
    input  wire        Ready,
    input  wire [31:0] Init1,     // sin(b)
    input  wire [31:0] Init2,     // 2cos(b)
    input  wire        FreqChng,
    input  wire [ 2:0] Mode,
    output wire [31:0] Out1,
    output wire [31:0] Out2
);
  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//
  reg [31:0] a;
  reg [31:0] b;
  reg [63:0] c;
  reg [31:0] Out1_a;
  reg [31:0] Out;
  reg [31:0] rOut1;
  reg [31:0] rOut2;
  reg        Zero_Cross;
  reg        Update_Wait;
  reg        Do_Update;
  reg        Dir;  // 0 = up , 1 = down

  //----------------------------------------//
  // Output Declaration
  //----------------------------------------//
  assign Out1 = rOut1;
  assign Out2 = rOut2;

  //----------------------------------------//
  // Process Declaration
  //----------------------------------------//

  // c = a * Out1
  always @(*) begin : for_combination_from_Formula
    c = $signed(a) * $signed(Out1);
  end

  always @(*) begin : u_Out1_a
    Out1_a = c[60:29];
  end

  // Out = Out1_a - Out2 = Out1_a + c*Out2
  always @(*) begin : u_Out
    Out = Out1_a - Out2;
  end

  // a = 2cos(B)
  always @(posedge Fg_Clk or negedge RESETn) begin : u_a
    if (!RESETn) begin
      a <= 31'd0;
    end else if (Ready) begin
      a <= Init2;
    end
  end

  // for Out1
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rOut1
    if (!RESETn) begin
      rOut1 <= 32'd0;
    end else if (Ready) begin
      rOut1 <= Init1;
    end else if (Enable) begin
      rOut1 <= Out;
    end
  end

  // for Out2
  always @(posedge Fg_Clk or negedge RESETn) begin : u_rOut2
    if (!RESETn) begin
      rOut2 <= 32'd0;
    end else if (Ready) begin
      rOut2 <= 32'd0;
    end else if (Enable) begin
      rOut2 <= Out1;
    end
  end

  // Update_wait for Change Freq. 
  always @(posedge Fg_Clk or negedge RESETn) begin : u_Update_Wait
    if (!RESETn) begin
      Update_Wait <= 1'b0;
    end else begin
      Update_Wait <= (FreqChng) ? 1'b1 : (Zero_Cross) ? 1'b0 : Update_Wait;
    end
  end

  // toggle Zero for check origin point of sine wave
  always @(*) begin : u_Zero
    if (Mode != 3'd4) begin  // for mode 0-3 : check 10 bits 
      Zero_Cross = (rOut1[31:22] == 10'b0000000000 || rOut1[31:22] == 10'b1111111111) ? 1'b1 : 1'b0;
    end else begin  // for mode 4 : check 9 bits
      Zero_Cross = (rOut1[31:23] == 9'b0000000000 || rOut1[31:23] == 10'b1111111111) ? 1'b1 : 1'b0;
    end
  end

  //Direction of sine wave 
  always @(*) begin : u_Dir
    Dir = ~rOut2[31];
  end

  // toggle Do_Update for change Freq.
  always @(*) begin : u_Do_Update
    Do_Update = (Zero_Cross && Update_Wait) ? 1'b1 : 1'b0;
  end

  //----------------------------------------//
endmodule
/*

         [ fs = 24 MHz] from Clk_Div(24 Mhz Phase 0 degree) 
         [ Ts = 1/fs]
         [ f = Freq. Need!!!! Ex(10kHz , 100kHz )]
         [ B = 2*pi*f*Ts]  

define : a = 2cos(B) , c = -1
y[n] = 2cos(B)y[n-1] - y[n-2]
y[n] = ay[n-1] + c*y[n-2]

out --> [ Z⁻¹ ] --> Out1 --> [ Z⁻¹ ] --> Out2 --> + --> out
                      |                           ^
                      V                           |
                    [ ×a ]                        |
                      |                           |
                  [ Out_1a ]                      |
                      |                           |
                      |_ _ _ _ _ _ _ _ _ _ _ _ _ _|

*/
