module DDS_Top (
    input Ext_Clk_27
);

  PLL_Top m_pll (
      .clkin(Ext_Clk_27),
      .reset(1'b0)  //1'b0
      //.clkout(),
      //.lock(PLL_Lock)
  );

  //Clk_div m_clk_div ();
endmodule
