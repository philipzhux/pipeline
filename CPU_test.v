module `include ".v"
`timescale 1ns/1ns

module testbench ();
  reg clk,rst;
  wire stop;
  MIPS CPU (clk, rst, stop);

  initial begin
    clk=1;
    while (stop != 1) begin
        #50
        clk=~clk;
    end
    for (i=0; i < 512; i = i + 1) begin
      $strobe  ("%b", CPU.MainRAM.DATA_RAM[i]);
    end
  end

  initial begin
    rst = 1;
    forwarding_EN = 0;
    #100
    rst = 0;
  end
endmodule // test