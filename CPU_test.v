`timescale 1ns/1ns
`include "CPU.v"
module testbench ();
  reg clk,rst,i;
  wire stop;
  
  CPU MIPS (clk, rst, stop);

  initial begin
    clk=1;
    while (stop != 1) begin
        #50
        clk=~clk;
    end
    for (i=0; i < 512; i = i + 1) begin
      $strobe  ("%b", MIPS.MainRAM.DATA_RAM[i][31:0]);
    end
  end

  initial begin
    rst = 1;
    #100
    rst = 0;
  end
endmodule // test