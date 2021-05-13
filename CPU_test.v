`timescale 1ns/1ns
`include "CPU.v"
module testbench ();
  parameter HALF_PERIOD = 10;
  reg clk,rst;
  integer i,f;
  wire stop;
  CPU MIPS (clk, rst, stop);
  initial begin
    clk = 0;
    #1 rst = 1'b1;
    #HALF_PERIOD clk=~clk;
    #1 rst = 1'b0;
    while (MIPS.RB_Instr!==32'hffff_ffff) begin
       #HALF_PERIOD clk=~clk;
    end
    f = $fopen("result.txt","w");
    for (i=0; i < 512; i = i + 1) begin
      $fwrite(f,"%b\n", MIPS.MainRAM.DATA_RAM[i]);
    end
    $fclose(f);
    $finish;
  end
endmodule // test