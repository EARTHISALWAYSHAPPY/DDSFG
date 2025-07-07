module rPLL (
    output CLKOUT,
    output LOCK,
    output CLKOUTP,
    output CLKOUTD,
    output CLKOUTD3,
    input RESET,
    input RESET_P,
    input CLKIN,
    input CLKFB,
    input [5:0] FBDSEL,
    input [5:0] IDSEL,
    input [5:0] ODSEL,
    input [3:0] PSDA,
    input [3:0] DUTYDA,
    input [3:0] FDLY
);

  reg clk = 0;
  reg [7:0] counter = 0;
  reg locked = 0;

  // ปลอม PLL Output clock ให้เร็วขึ้นกว่า input
  always #5 clk = ~clk;  // ~100 MHz output

  // ปลอม lock: delay นิดหน่อยก่อนขึ้น 1
  always @(posedge CLKIN) begin
    counter <= counter + 1;
    if (counter > 10) locked <= 1;
  end

  assign CLKOUT = clk;
  assign LOCK = locked;
  assign CLKOUTP = clk;
  assign CLKOUTD = clk;
  assign CLKOUTD3 = clk;

endmodule
