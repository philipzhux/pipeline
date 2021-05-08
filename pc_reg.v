module PCReg (rawPC,outPC,reset,PC_Stall);
input wire [31:0] rawPC;
input reset,clk;
input PC_Stall;
output reg [31:0] outPC;
always@(posedge reset) outPC <= 32'hFFFFFFFC;
always @(*)
  begin
	  if (PC_Stall==1'b0)
		  begin
        outPC <= rawPC;
		  end
  end
endmodule