//----------------------------------------//
// Filename     : Interpolator.v
// Description  : Interpolator module for DDSFG.
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 13.07.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//
module Interpolator (
    input  wire               Fg_Clk,
    input  wire               RESETn,
    input  wire signed [31:0] Out1,
    input  wire signed [31:0] Out2,
    input  wire        [ 2:0] Mode,
    input  wire               Enable,
    output wire        [11:0] InterpOut
);
  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//
  reg               Enable_delay;
  reg signed [31:0] Const;
  reg        [63:0] delta;
  reg        [31:0] Output;
  reg        [11:0] rInterpOut;

  //----------------------------------------//
  // Output Declaration
  //----------------------------------------//
  assign InterpOut = rInterpOut;

  //----------------------------------------//
  // Process Declaration
  //----------------------------------------//

  // Delay Enable 1 cycle
  always @(posedge Fg_Clk or negedge RESETn) begin : u_Enable_delay
    if (!RESETn) begin
      Enable_delay <= 1'b0;
    end else begin
      Enable_delay <= Enable;
    end
  end

  // Constant select Mode
  always @(posedge Fg_Clk or negedge RESETn) begin : u_Const
    if (!RESETn) begin
      Const <= 32'd1;
    end else begin
      case (Mode)
        3'd0: Const <= 32'd1;
        3'd1: Const <= 32'd53687091;
        3'd2: Const <= 32'd5368709;
        3'd3: Const <= 32'd536871;
        3'd4: Const <= 32'd53687;
        default: Const <= 32'd1;
      endcase
    end
  end

  // interpolated : Out2 and Out1
  always @(posedge Fg_Clk or negedge RESETn) begin : u_Output
    if (!RESETn) begin
      Output <= 32'd0;
    end else if (Enable_delay) begin
      Output <= Out2;
    end else begin
      Output <= Output + delta[60:29];
    end
  end

  // Delta cal , interpolation output
  always @(*) begin : u_InterpComb
    delta      = (Out1 - Out2) * Const;
    rInterpOut = Output[29:18];
  end

  //----------------------------------------//
endmodule

// Note...........
// signed : Permitted val. -/+ 
// if dont use signal will be crazy.
