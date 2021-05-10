module PCReg (rawPC,outPC,reset,clk,PC_Stall);
input wire [31:0] rawPC;
input reset,clk;
input PC_Stall;
output reg [31:0] outPC;
always @(posedge clk)
  begin
	  if (PC_Stall!==1'b1)
		  begin
        if (reset==1'b0) outPC <= rawPC;
        else outPC <= 32'hFFFF_FFFC;
		  end
  end
endmodule