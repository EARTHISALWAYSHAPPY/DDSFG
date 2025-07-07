`timescale 1ns / 1ps

module DDS_Top_tb;

  // Signals
  reg  Ext_Clk_27;
  wire PLL_Clock;
  wire PLL_Lock;

  // Instantiate DUT
  DDS_Top uut (
      .Ext_Clk_27(Ext_Clk_27),
      .PLL_Clock (PLL_Clock),
      .PLL_Lock  (PLL_Lock)
  );

  // Clock gen: 27 MHz = 37.037ns period
  always #18.5185 Ext_Clk_27 = ~Ext_Clk_27;

  initial begin
    // Init
    Ext_Clk_27 = 0;

    // Simulation run time
    $display("Start Simulation");
    #2000;  // run 2us

    $display("End Simulation");
    $stop;
  end

endmodule
