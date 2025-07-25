`timescale 1ns / 1ps
module Signal_Gen (
    output reg Ext_RESETn,
    output reg ExtBtn,
    output reg Ext_Rot_A,
    output reg Ext_Rot_B,
    output reg Ext_Btn_Rot_C
);
  initial begin  // มั่วค่ามา test only!!!!
    Ext_RESETn = 1;
    ExtBtn = 1;
    Ext_Rot_A = 1;
    Ext_Rot_B = 1;
    Ext_Btn_Rot_C = 1;

    // Reset
    #240000;
    Ext_RESETn = 0;
    #5;
    Ext_RESETn = 1;
    #240000;

    Func_Btn(50);
    CW(50);
    CW(50);

    #24000;
    Btn_C(500);
    #2400;
    Btn_C(500);
    #240;
    repeat (6) CCW(50);
    #240;
    Func_Btn(50);
    #24000;
    Func_Btn(50);
    #24000;
    Func_Btn(50);
    #24000;
    repeat (100) CCW(50);
    #240;

  end

  task CW;
    input integer delay_ns;
    begin
      Ext_Rot_A = 1;
      Ext_Rot_B = 1;
      #delay_ns;
      Ext_Rot_A = 1;
      Ext_Rot_B = 0;
      #delay_ns;
      Ext_Rot_A = 0;
      Ext_Rot_B = 0;
      #delay_ns;
      Ext_Rot_A = 0;
      Ext_Rot_B = 1;
      #delay_ns;
      Ext_Rot_A = 1;
      Ext_Rot_B = 1;
      #delay_ns;
    end
  endtask

  // Rotate CCW: 00 → 10 → 11 → 01 → 00
  task CCW;
    input integer delay_ns;
    begin
      Ext_Rot_A = 1;
      Ext_Rot_B = 1;
      #delay_ns;
      Ext_Rot_A = 0;
      Ext_Rot_B = 1;
      #delay_ns;
      Ext_Rot_A = 0;
      Ext_Rot_B = 0;
      #delay_ns;
      Ext_Rot_A = 1;
      Ext_Rot_B = 0;
      #delay_ns;
      Ext_Rot_A = 1;
      Ext_Rot_B = 1;
      #delay_ns;
    end
  endtask

  // Button C
  task Btn_C;
    input integer press_time;
    begin
      Ext_Btn_Rot_C = 0;
      #press_time;
      Ext_Btn_Rot_C = 1;
      #press_time;
    end
  endtask

  // Button gen
  task Func_Btn;
    input integer press_time;
    begin
      ExtBtn = 0;
      #press_time;
      ExtBtn = 1;
      #press_time;
    end
  endtask

endmodule
