module Lookup_Table (
    input  wire        Fg_Clk,
    input  wire        RESETn,
    input  wire [10:0] Address,
    input  wire [31:0] Out1,
    input  wire [31:0] Out2,
    output wire [31:0] Sin1x,
    output wire [31:0] Cos2x
);

  reg [47:0] Coefficient;
  assign Sin1x = {4'b0000, Coefficient[47:24], 4'b0000};
  assign Cos2x = {6'b001111, Coefficient[23:0], 2'b00};

  romcoef_module m_romcoef (
      .dout(Coefficient),  //output [47:0] dout
      .clk(Fg_Clk),  //input clk
      .oce(1'b1),  //input oce (1 = pipeline)
      .ce(1'b1),  //input ce (1 = Awaken Chip)
      .reset(~RESETn),  //input reset
      .ad(Address)  //input [10:0] ad
  );

endmodule
