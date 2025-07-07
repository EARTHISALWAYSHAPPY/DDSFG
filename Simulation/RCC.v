//RCC only sim.

//`timescale 1ms/1us
`timescale 1ns / 1ps

module RCC (
    output wire Ext_Clk
    //output wire RESETn  //wait Reset Gen
);
  reg rExt_Clk;
  //reg rRESETn;

  assign Ext_Clk = rExt_Clk;
  //assign RESETn = rRESETn;

  initial begin : u_rExt_Clk
    rExt_Clk <= 1'd0;
    repeat (2000) begin // repeat 2000 round
      //#15.625 // # same delay in slimu. (32 hz)
      #18.5185  // from freq of clk tang 9k : 27 Mhz ( 1/27 MHz)  
      rExt_Clk <= ~rExt_Clk;
    end
    $stop;
  end

  // from requirement need clk 32 hz.
  // frq to period is 1/32 = 31.25 ms 
  // so toggle 31.25/2 = 15.625 ms

  //   initial begin : u_rCRESETn
  //     rRESETn <= 1'd0;
  //     repeat (10) begin
  //       @(posedge rCLK);  // same while loop 
  //     end
  //     rRESETn <= 1'd1;
  //   end

  // wait 10 repeat posedge 10 clk

endmodule
