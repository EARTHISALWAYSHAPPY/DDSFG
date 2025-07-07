module DDS_Top (
    input  Ext_Clk_27,
    output PLL_Clock,
    output PLL_Lock
);

  PLL_Top m_pll (
      .clkin (Ext_Clk_27),
      .reset (1'b0),
      .clkout(PLL_Clock),
      .lock  (PLL_Lock)
  );

endmodule
