module RegisterFile(clk,reset,RD1, RD2, WriteReg, WriteData, RegWrite, ReadData1, ReadData2);
	input [4:0] RD1 ,RD2 ,WriteReg;
	input [31:0] WriteData;
	input RegWrite,reset,clk;
	output reg [31:0] ReadData1 ,ReadData2;
	reg [31:0] memory[0:31];
	always @ (posedge clk)
	begin
			if(reset!==1'b0) begin
			memory[0] <= 32'h00000000;
			memory[1] <= 32'h00000000;
			memory[2] <= 32'h00000000;
			memory[3] <= 32'h00000000;
			memory[4] <= 32'h00000000;
			memory[5] <= 32'h00000000;
			memory[6] <= 32'h00000000;
			memory[7] <= 32'h00000000;
			memory[8] <= 32'h00000001;
			memory[9] <= 32'h00000002;
			memory[10] <= 32'h00000000;
			memory[11] <= 32'h00000000;
			memory[12] <= 32'h00000000;
			memory[13] <= 32'h00000000;
			memory[14] <= 32'h00000000;
			memory[15] <= 32'h00000000;
			memory[16] <= 32'h00000000;
			memory[17] <= 32'h00000000;
			memory[18] <= 32'h00000003;
			memory[19] <= 32'h00000003;
			memory[20] <= 32'h00000004;
			memory[21] <= 32'h00000000;
			memory[22] <= 32'h00000008;
			memory[23] <= 32'h00000000;
			memory[24] <= 32'h00000000;
			memory[25] <= 32'h00000000;
			memory[26] <= 32'h00000000;
			memory[27] <= 32'h00000000;
			memory[28] <= 32'h00000000;
			memory[29] <= 32'h00000000;
			memory[30] <= 32'h00000000;
			memory[31] <= 32'h00000000;
		end
		 #2;
	  if(RegWrite==1) memory[WriteReg] <= WriteData;
	end
	always @(negedge clk)
	begin
		ReadData1 <= memory[RD1];
  		ReadData2 <= memory[RD2];
	end

endmodule
