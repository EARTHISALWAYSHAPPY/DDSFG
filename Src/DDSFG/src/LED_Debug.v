//----------------------------------------//
// Filename     : LED_Debug.v
// Description  : Rotary Encoder Module for DDSFG
// Company      : KMITL
// Project      : DDSFG
//----------------------------------------//
// Version      : 00.01
// Date         : 04.08.2025
// Author       : Kunanon Wanyen
// Remark       : Creation File
//----------------------------------------//
module LED_Debug (
    input wire Fg_Clk, 
    input wire RESETn,  
    input wire [2:0] Mode,  
    input wire [1:0] Mode_Step,  
    output wire [2:0] LED_Mode,  
    output wire [1:0] LED_Mode_Step 
);

  //----------------------------------------//
  // Signal Declaration
  //----------------------------------------//
  reg [2:0] rLED_Mode; 
  reg [1:0] rLED_Mode_Step;  

  //----------------------------------------//
  // Output Assignments
  //----------------------------------------//
  assign LED_Mode = rLED_Mode;
  assign LED_Mode_Step = rLED_Mode_Step;

  //----------------------------------------//
  // Sequential Logic : Register inputs on clock edge
  //----------------------------------------//
  always @(posedge Fg_Clk or negedge RESETn) begin
    if (!RESETn) begin
      rLED_Mode <= 3'd0;  // Reset Mode display to 0
      rLED_Mode_Step <= 2'd0;  // Reset Mode_Step display to 0
    end else begin
      rLED_Mode <= Mode;  // Update registered Mode with input
      rLED_Mode_Step <= Mode_Step;  // Update registered Mode_Step with input
    end
  end
endmodule
