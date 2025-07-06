module DDS_Top (
    input Ext_Clk_27
);

  PLL_top pll (
      .clkin(Ext_Clk_27),
      //.reset (~PLL_Reset), 1'b0
      //.clkout(PLL_Clock),
      //.lock  (PLL_Lock)
  );
endmodule
