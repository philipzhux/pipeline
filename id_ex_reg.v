module ID_EX_Reg(clk,RegWriteD,MemtoRegD,MemWriteD,ALUControlD,ALUSrcD,RegDstD,
ReadData1,ReadData2,RsD,RtD,RdD,SignImmD,ShamtD,LinkD,PCPlus4D,InstrD,RegWriteE,MemtoRegE,MemWriteE,ALUControlE,ALUSrcE,
RegDstE,ReadData1E,ReadData2E,RsE,RtE,RdE,SignImmE,ShamtE,LinkE,PCPlus4E,InstrE);
input clk,RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD,LinkD;
input wire [3:0] ALUControlD;
input wire [4:0] RsD,RtD,RdD,ShamtD;
input wire [31:0] ReadData1,ReadData2,SignImmD,PCPlus4D,InstrD;
output reg RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE,LinkE;
output reg[3:0] ALUControlE;
output reg[4:0] RsE,RtE,RdE,ShamtE;
output reg[31:0] ReadData1E,ReadData2E,SignImmE,PCPlus4E,InstrE;
always @(posedge clk)
begin
    RegWriteE <= RegWriteD;
    MemtoRegE <= MemtoRegD;
    MemWriteE <= MemWriteD;
    ALUSrcE <= ALUSrcD;
    RegDstE <= RegDstD;
    ALUControlE<=ALUControlD;
    RsE <= RsD;
    RtE <= RtD;
    RdE <= RdD;
    ShamtE <= ShamtD;
    ReadData1E <= ReadData1;
    ReadData2E <= ReadData2;
    SignImmE <= SignImmD;
    PCPlus4E <= PCPlus4D;
    LinkE <= LinkD;
    InstrE <= InstrD;
end
endmodule //id_ex_reg
