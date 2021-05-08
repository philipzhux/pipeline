module HazardDetectionUnit(IF_ID_OP,IF_ID_Funct,IF_ID_RS,IF_ID_RT,ID_EX_MemtoReg,ID_EX_RT,ID_EX_RD,EX_MEM_WriteReg,
ID_EX_RegWrite,EX_MEM_RegWrite,EqualFlag,PC_Stall,IF_ID_Stall,IF_ID_Flush,Control_Mux,IF_ID_invalidRt,EX_MEM_MemtoReg);
input ID_EX_MemtoReg,ID_EX_RegWrite,EX_MEM_RegWrite,EX_MEM_MemtoReg,EqualFlag,IF_ID_invalidRt;
input wire[4:0] IF_ID_RS,IF_ID_RT,ID_EX_RT,ID_EX_RD,EX_MEM_WriteReg;
input wire[5:0] IF_ID_OP,IF_ID_Funct;
output reg PC_Stall,IF_ID_Stall,IF_ID_Flush,Control_Mux;
parameter R_Type = 6'b000000;
parameter J = 6'b000010;
parameter JAL = 6'b000011;
parameter BEQ = 6'b000100;
parameter BNE = 6'b000101;
parameter JR = 6'b001000;
  initial
	begin
	PC_Stall <= 0;
	IF_ID_Stall <= 0;
	Control_Mux <= 0;
	end
always @(IF_ID_OP,IF_ID_RS,IF_ID_RT,ID_EX_MemtoReg,ID_EX_RT,ID_EX_RD,EX_MEM_WriteReg,ID_EX_RegWrite,EX_MEM_RegWrite,EqualFlag) begin
if((ID_EX_MemtoReg == 1'b1) && ((ID_EX_RT == IF_ID_RS) || (ID_EX_RT == IF_ID_RT && ~IF_ID_invalidRt))) begin
			PC_Stall <= 1'b1;
			Control_Mux <= 1'b1;
			IF_ID_Flush <= 1'b0;
			IF_ID_Stall <= 1'b1;
end else if(((IF_ID_OP == BEQ) || (IF_ID_OP == BNE) || ((IF_ID_OP == R_Type) && (IF_ID_Funct == JR))) 
		&& (((ID_EX_RD == IF_ID_RS || (ID_EX_RD == IF_ID_RT && ~IF_ID_invalidRt)) && (ID_EX_RegWrite == 1'b1)) ||
		 ((EX_MEM_WriteReg == IF_ID_RS || (EX_MEM_WriteReg == IF_ID_RT && ~IF_ID_invalidRt)) 
    && (EX_MEM_RegWrite == 1'b1) && (EX_MEM_MemtoReg == 1'b1)))) begin //for branch alike: [EX not ready] or [MEM not ready(when memtoreg==1)]
			PC_Stall <= 1'b1;
			Control_Mux <= 1'b1;
			IF_ID_Flush <= 1'b0;
			IF_ID_Stall <= 1'b1;
end else if((IF_ID_OP == J) || (IF_ID_OP == JAL) || ((IF_ID_OP == R_Type) && (IF_ID_Funct == JR)) || 
(IF_ID_OP == BEQ && (EqualFlag == 1'b1)) || (IF_ID_OP == BNE && (EqualFlag == 1'b0))) begin
			PC_Stall <= 1'b0;
			Control_Mux <= 1'b0;
			IF_ID_Flush <= 1'b1;
			IF_ID_Stall <= 1'b0;
end else begin
			PC_Stall <= 1'b0;
			Control_Mux <= 1'b0;
			IF_ID_Flush <= 1'b0;
			IF_ID_Stall <= 1'b0;
end
end
endmodule