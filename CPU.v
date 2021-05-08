module CPU(clk,Reset,stop);
input wire clk, Reset;
output reg stop;
wire Ctl_Mux,EqualFlag,PC_Stall,ID_ALUSrc,ID_Branch;
wire EX_ALUSrc,EX_Link,EX_MemtoReg,EX_MemWrite,EX_RegDst,EX_RegWrite;
wire ID_Link,ID_MemtoReg,ID_MemWrite,ID_RegDst,ID_RegWrite,IF_ID_Flush,IF_ID_Stall,invalidRt;
wire MEM_Link,MEM_MemtoReg,MEM_MemWrite,MEM_RegWrite,RB_Link,RB_MemtoReg,RB_RegWrite;
wire[1:0] ID_JBFlag,EX_RS_Mux_Signal,EX_RT_Mux_Signal,ID_RS_Mux_Signal,ID_RT_Mux_Signal;
wire[3:0] EX_ALUCtl,ID_ALUCtl;
wire[4:0] EX_RD,EX_RS,EX_RT,EX_Shamt,EX_WriteReg,ID_RS,ID_RT,ID_RD,ID_Shamt;
wire[4:0] RB_WriteReg,RB_WriteReg_B4Link,MEM_WriteReg;
wire[5:0] ID_Funct,ID_OP;
wire[15:0] ID_Imm,ID_ShiftImm,ID_SignImm;
wire[31:0] EX_ALUOut,EX_PCPlus4,EX_ReadData1,EX_ReadData2,ID_Instr,ID_JRawAddr;
wire[31:0] EX_SignImm,EX_SrcA,EX_SrcB,EX_WriteData,ID_BranchPara1,ID_BranchPara2;
wire[31:0] ID_PCBranch,ID_PCJump,ID_PCPlus4,ID_ReadData1,ID_ReadData2,IF_Instr,IF_PC,IF_PCPlus4,MEM_ALUOut;
wire[31:0] MEM_PCPlus4, MEM_ReadData, MEM_WriteData,PCRaw,RB_ALUOut,RB_PCPlus4,RB_ReadData,RB_Result,RB_Result_B4Link;
parameter Reg_RA = 5d'31;
//=================================DEALING WITH HAZARD=================================

Forwarding Forward(ID_RS_Mux_Signal,ID_RT_Mux_Signal,EX_RS_Mux_Signal,EX_RT_Mux_Signal,ID_RS,ID_RT,EX_RS,EX_RT,
MEM_RegWrite,MEM_WriteReg,MEM_ALUOut,RB_RegWrite,RB_WriteReg,RB_ReadData);
//(ID_RS_Mux_Signal,ID_RT_Mux_Signal,EX_RS_Mux_Signal,EX_RT_Mux_Signal,
//ID_RS,ID_RT,EX_RS,EX_RT,EX_MEM_RegWrite,EX_MEM_WriteReg,EX_MEM_ALUout,MEM_RB_RegWrite,MEM_RB_WriteReg,MEM_RB_ReadDataW);
HazardDetectionUnit Detect(ID_OP,ID_Funct,ID_RS,ID_RT,EX_MemtoReg,EX_RT,EX_RD,MEM_WriteReg,EX_RegWrite,MEM_RegWrite,EqualFlag,PC_Stall,IF_ID_Stall,Ctl_Mux,invalidRt);
// (IF_ID_OP,IF_ID_Funct,IF_ID_RS,IF_ID_RT,ID_EX_MemtoReg,ID_EX_RT,ID_EX_RD,EX_MEM_WriteReg,
// ID_EX_RegWrite,EX_MEM_RegWrite,EqualFlag,PC_Stall,IF_ID_Stall,Control_Mux,invalidRt)

//=====================================STAGE 1: IF=====================================

Mux3x32 PCMux(ID_JBFlag,IF_PCPlus4,ID_PCBranch,ID_PCJump,PCRaw);//Mux Syntax: Signal, In, In, Out
PCReg PCHolder(PCRaw,IF_PC,Reset,PC_Stall);//PCReg Syntax: rawPC,outPC,Reset,stall
Add PCAdder(IF_PC,32'h00000004,IF_PCPlus4);
InstructionRAM InsMem(1'b0,1'b1,IF_PC<<2,IF_Instr);
StopControl StopOrNot(IF_Instr,stop);
IF_ID_Reg IF_ID_Register(clk,IF_PCPlus4,IF_Instr,IF_ID_Stall,IF_ID_Flush,ID_PCPlus4,ID_Instr);
//clk,IF_PCPlus4,IF_Instr,IF_Stall,IF_Flush,PCPlus4D,InstrD

//=====================================STAGE 2: ID=====================================

Parser InsParse(ID_Instr,ID_OP,ID_Funct,ID_RS,ID_RT,ID_RD,ID_Shamt,ID_Imm,ID_JRawAddr);//in,op,funct,rs,rt,rd,shamt,imm
RegisterFile RF(Reset,ID_RS,ID_RT,RB_WriteReg,RB_Result,RB_RegWrite,ID_ReadData1,ID_ReadData2);
//Reset,ReadData1, ReadData2, WriteReg, WriteData, RegWrite, ReadData1, ReadData2
SignExt SignExtension(ID_Imm,ID_SignImm);
ShiftLeftBy2 Shift(ID_SignImm,ID_ShiftImm);
Add BranchAdd(ID_PCPlus4,ID_ShiftImm,ID_PCBranch);//add: in-in-out
ControlUnit Control(Reset,Ctl_Mux,ID_OP,ID_Funct,ID_RegWrite,ID_MemtoReg,ID_Branch,ID_ALUCtl,ID_ALUSrc,ID_RegDst,ID_MemWrite,invalidRt);
//Reset,CtlMux,op,funct,RegWrite,MemtoReg,Branch,ALUControl,ALUSrc,RegDst,MemWrite
Mux3x32 FW_ID_RS_Mux(ID_RS_Mux_Signal,ID_ReadData1,MEM_ALUOut,RB_Result,ID_BranchPara1);
Mux3x32 FW_ID_RT_Mux(ID_RT_Mux_Signal,ID_ReadData2,MEM_ALUOut,RB_Result,ID_BranchPara2);
//ID_RS_Mux_Signal: 00 to get original; 01 to get EX_MEM_ALUOut; 10 to get MEM_RB_Result
//ID_RT_Mux_Signal: 00 to get original; 01 to get EX_MEM_ALUOut; 10 to get MEM_RB_Result
//EX_RS_Mux_Signal: 00 to get original; 01 to get EX_MEM_ALUOut; 10 to get MEM_RB_Result
//EX_RT_Mux_Signal: 00 to get original; 01 to get EX_MEM_ALUOut; 10 to get MEM_RB_Result
Comparator BranchCompare(ID_BranchPara1,ID_BranchPara2,EqualFlag);
JBControl JBSignal(ID_OP,ID_Funct,EqualFlag,ID_JBFlag);
JumpMux JumpAddr(ID_OP,ID_Funct,ID_JRawAddr,ID_PCPlus4,ID_BranchPara1,ID_PCJump);
//branchOrNot BranchSignal(ID_OP,EqualFlag,ID_BranchFlag);
LinkControl LC(ID_OP,ID_Link);
ID_EX_Reg ID_EX_Register(clk,ID_RegWrite,ID_MemtoReg,ID_MemWrite,ID_ALUCtl,ID_ALUSrc,ID_RegDst,
ID_ReadData1,ID_ReadData2,ID_RS,ID_RT,ID_RD,ID_SignImm,ID_Shamt,ID_Link,ID_PCPlus4,EX_RegWrite,EX_MemtoReg,EX_MemWrite,EX_ALUCtl,EX_ALUSrc,EX_RegDst,
EX_ReadData1,EX_ReadData2,EX_RS,EX_RT,EX_RD,EX_SignImm,EX_Shamt,EX_Link,EX_PCPlus4);
// clk,RegWriteD,MemtoRegD,MemWriteD,ALUControlD,ALUSrcD,RegDstD,
// ReadData1,ReadData2,RsD,RtD,RdD,SignImmD,ShamtD,RegWriteE,MemtoRegE,MemWriteE,ALUControlE,ALUSrcE,
// RegDstE,ReadData1E,ReadData2E,RsE,RtE,RdE,SignImmE,ShamtE

//=====================================STAGE 3: EX=====================================

Mux2x32 RegDstMux(EX_RegDst,EX_RT,EX_RD,EX_WriteReg);
Mux3x32 FW_EX_RS_Mux(EX_RS_Mux_Signal,EX_ReadData1,MEM_ALUOut,RB_Result,EX_SrcA);
Mux3x32 FW_EX_RT_Mux(EX_RT_Mux_Signal,EX_ReadData2,MEM_ALUOut,RB_Result,EX_WriteData);
Mux2x32 EX_SrcB_Mux(EX_ALUSrc,EX_WriteData,EX_SignImm,EX_SrcB);
ALU32 ALU(EX_SrcA,EX_SrcB,EX_ALUCtl,EX_Shamt,EX_ALUOut);//in1, in2, ALUControl, shamt, res
EX_MEM_Reg EX_MEM_Register(clk,EX_RegWrite,EX_MemtoReg,EX_MemWrite,EX_WriteReg,EX_ALUOut,EX_WriteData,EX_Link,EX_PCPlus4
MEM_RegWrite,MEM_MemtoReg,MEM_MemWrite,MEM_WriteReg,MEM_ALUOut,MEM_WriteData,MEM_Link,MEM_PCPlus4);
// clk,RegWriteE,MemtoRegE,MemWriteE,WriteRegE,EX_ALUOut,EX_WriteData
// RegWriteM,MemtoRegM,MemWriteM,WriteRegM,MEM_ALUOut,MEM_WriteData

//=====================================STAGE 4: MEM=====================================

MainMemory MainRAM(1'b0,1'b1,MEM_ALUOut<<2,{MEM_MemWrite,MEM_ALUOut<<2,MEM_WriteData},MEM_ReadData);
Mem_RB_Reg MEM_RB_Register(clk,MEM_RegWrite,MEM_MemtoReg,MEM_WriteReg,MEM_ReadData,MEM_ALUOut,MEM_Link,MEM_PCPlus4,RB_RegWrite,
RB_MemtoReg,RB_WriteReg_B4Link,RB_ReadData,RB_ALUOut,RB_Link,RB_PCPlus4);
// clk,RegWriteM,MemtoRegM,WriteRegM,RD,ALUOutM,RegWriteW,MemtoRegW,
// WriteRegW,ReadDataW,ALUOutW

//====================================STAGE 5: WB/RB====================================

Mux2x32 RBMux(RB_MemtoReg,RB_ALUOut,RB_ReadData,RB_Result_B4Link);
Mux2x32 LinkResultMux(RB_Link,RB_Result_B4Link,RB_PCPlus4,RB_Result);
Mux2x5 LinkWriteRegMux(RB_Link,RB_WriteReg_B4Link,Reg_RA,RB_WriteReg);

endmodule
