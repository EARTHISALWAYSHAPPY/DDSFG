`timescale 1ns / 1ps
module Signal_Gen (
    output reg Ext_RESETn,
    output reg ExtBtn
);
  initial begin  // มั่วค่ามา test only!!!!
    Ext_RESETn = 1;
    ExtBtn     = 1;

    #10000;
    Ext_RESETn = 0;
    #5;
    Ext_RESETn = 1;
    #1000;

    ExtBtn = 1;
    #2400000;
    ExtBtn = 0;
    #500;
    ExtBtn = 1;
    #2400000;

    ExtBtn = 1;
    #2400000;
    ExtBtn = 0;
    #500;
    ExtBtn = 1;
    #2400000;
    Ext_RESETn = 0;
    #5;
    Ext_RESETn = 1;
    #10000;

    ExtBtn = 1;
    #2400000;
    ExtBtn = 0;
    #500;
    ExtBtn = 1;
    #2400000;

    ExtBtn = 1;
    #2400000;
    ExtBtn = 0;
    #500;
    ExtBtn = 1;
    #2400000;

    ExtBtn = 1;
    #2400000;
    ExtBtn = 0;
    #500;
    ExtBtn = 1;
    #2400;
    ExtBtn = 0;
    #500;
    ExtBtn = 1;
    #2400;

    ExtBtn = 1;
    #2400000;
    ExtBtn = 0;
    #500;
    ExtBtn = 1;
    #2400000;

    ExtBtn = 1;
    #2400000;
    ExtBtn = 0;
    #500;
    ExtBtn = 1;
    #2400000;
  end

endmodule
