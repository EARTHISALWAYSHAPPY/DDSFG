module Rotary_Encoder (
    input wire Fg_Clk,
    input wire RESETn,
    input wire A,
    input wire B,
    input wire C,
    output wire Address,
    output wire [10:0] FreqChng
);

  wire wRot_C;
  reg  Rot_C;
  assign Rot_C = wRot_C;
  
  Btn_Interface_Rot_C m_btn_unterface_rot_c (
      .Fg_Clk(Fg_Clk),
      .RESETn(RESETn),
      .ExtBtn(C),
      .IntBtn(wRot_C)
  );

endmodule
