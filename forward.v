module Forwarding(ID_RS_Mux_Signal,ID_RT_Mux_Signal,EX_RS_Mux_Signal,EX_RT_Mux_Signal,
ID_RS,ID_RT,EX_RS,EX_RT,EX_MEM_RegWrite,EX_MEM_WriteReg,MEM_RB_RegWrite,MEM_RB_WriteReg,EX_MEM_MemtoReg);
input EX_MEM_RegWrite, MEM_RB_RegWrite, EX_MEM_MemtoReg;
input [4:0] EX_MEM_WriteReg,MEM_RB_WriteReg,ID_RS,ID_RT,EX_RS,EX_RT;
output reg [1:0] ID_RS_Mux_Signal, ID_RT_Mux_Signal, EX_RS_Mux_Signal, EX_RT_Mux_Signal;

always @(EX_MEM_RegWrite, MEM_RB_RegWrite, ID_RS, ID_RT, EX_RS, EX_RT) begin

if(ID_RS!=5'b00000 && ID_RS == EX_MEM_WriteReg && EX_MEM_RegWrite && EX_MEM_WriteReg && ~(EX_MEM_MemtoReg)) ID_RS_Mux_Signal<=2'b01;
else if(ID_RS!=5'b00000 && ID_RS == MEM_RB_WriteReg && MEM_RB_RegWrite && MEM_RB_WriteReg) ID_RS_Mux_Signal<=2'b10;
else ID_RS_Mux_Signal<=2'b00;

if(ID_RT!=5'b00000 && ID_RT == EX_MEM_WriteReg && EX_MEM_RegWrite && EX_MEM_WriteReg && ~(EX_MEM_MemtoReg)) ID_RT_Mux_Signal<=2'b01;
else if(ID_RT!=5'b00000 && ID_RT == MEM_RB_WriteReg && MEM_RB_RegWrite && MEM_RB_WriteReg) ID_RT_Mux_Signal<=2'b10;
else ID_RT_Mux_Signal<=2'b00;

if(EX_RS!=5'b00000 && EX_RS == EX_MEM_WriteReg && EX_MEM_RegWrite && EX_MEM_WriteReg && ~(EX_MEM_MemtoReg)) EX_RS_Mux_Signal<=2'b01;
else if(EX_RS!=5'b00000 && EX_RS == MEM_RB_WriteReg && MEM_RB_RegWrite && MEM_RB_WriteReg) EX_RS_Mux_Signal<=2'b10;
else EX_RS_Mux_Signal<=2'b00;

if(EX_RT!=5'b00000 && EX_RT == EX_MEM_WriteReg && EX_MEM_RegWrite && EX_MEM_WriteReg && ~(EX_MEM_MemtoReg)) EX_RT_Mux_Signal<=2'b01;
else if(EX_RT!=5'b00000 && EX_RT == MEM_RB_WriteReg && MEM_RB_RegWrite && MEM_RB_WriteReg) EX_RT_Mux_Signal<=2'b10;
else EX_RT_Mux_Signal<=2'b00;
end
//ID_RS_Mux_Signal: 00 to get original; 01 to get EX_MEM_ALUOut; 10 to get MEM_RB_ResultW
//ID_RT_Mux_Signal: 00 to get original; 01 to get EX_MEM_ALUOut; 10 to get MEM_RB_ResultW
//EX_RS_Mux_Signal: 00 to get original; 01 to get EX_MEM_ALUOut; 10 to get MEM_RB_ResultW
//EX_RT_Mux_Signal: 00 to get original; 01 to get EX_MEM_ALUOut; 10 to get MEM_RB_ResultW
endmodule