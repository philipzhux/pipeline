`timescale 1ns/1ns
`include "CPU.v"
module testbench ();
  parameter HALF_PERIOD = 10;
  reg clk,rst;
  integer i;
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

    for (i=0; i < 512; i = i + 1) begin
      $display("%b", MIPS.MainRAM.DATA_RAM[i]);
    end
    $display("xxx");
    for (i=0; i < 32; i = i + 1) begin
      $display("%b", MIPS.RF.memory[i]);
    end
    $finish;
  end


endmodule // test