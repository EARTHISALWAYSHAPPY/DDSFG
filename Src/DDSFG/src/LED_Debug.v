module LED_Debug (
    input wire Fg_Clk,
    input wire RESETn,
    input wire [2:0] Mode,
    input wire [1:0] Mode_Step,
    output wire [2:0] LED_Mode,
    output wire [1:0] LED_Mode_Step
);

  reg [2:0] rLED_Mode;
  reg [1:0] rLED_Mode_Step;

  assign LED_Mode = rLED_Mode;
  assign LED_Mode_Step = rLED_Mode_Step;

  always @(posedge Fg_Clk or negedge RESETn) begin

    if (!RESETn) begin
      rLED_Mode <= 3'd0;
      rLED_Mode_Step <= 2'd0;
    end else begin
      rLED_Mode <= Mode;
      rLED_Mode_Step <= Mode_Step;
    end
  end
endmodule
