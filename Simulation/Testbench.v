module Testbench ();

  wire Ext_RESETn;
  wire ExtBtn;
  wire Ext_Clk;
  wire Ext_Rot_A;
  wire Ext_Rot_B;
  wire Ext_Btn_Rot_C;
  wire Dac_Clk;
  wire [11:0] DDS_Out;

  RCC m_rcc (.Ext_Clk(Ext_Clk));

  Signal_Gen m_signal_gen (
      .Ext_RESETn(Ext_RESETn),
      .ExtBtn(ExtBtn),
      .Ext_Rot_A(Ext_Rot_A),
      .Ext_Rot_B(Ext_Rot_B),
      .Ext_Btn_Rot_C(Ext_Btn_Rot_C)
  );

  DDS_Top m_dss_top (
      .Ext_Clk      (Ext_Clk),
      .Ext_RESETn   (Ext_RESETn),
      .ExtBtn       (ExtBtn),
      .Ext_Rot_A    (Ext_Rot_A),
      .Ext_Rot_B    (Ext_Rot_B),
      .Ext_Btn_Rot_C(Ext_Btn_Rot_C),
      .Dac_Clk      (Dac_Clk),
      .DDS_Out      (DDS_Out)
  );

endmodule
