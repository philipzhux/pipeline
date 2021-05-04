module ID_EX_Reg(clk,RegWriteD,MemtoRegD,MemWriteD,ALUControlD,ALUSrcD,RegDstD,
ReadData1,ReadData2,RsD,RtD,RdD,SignImmD,ShamtD,LinkD,PCPlus4D,RegWriteE,MemtoRegE,MemWriteE,ALUControlE,ALUSrcE,
RegDstE,ReadData1E,ReadData2E,RsE,RtE,RdE,SignImmE,ShamtE,LinkE,PCPlus4E);
input clk,RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD,LinkD;
input wire [2:0] ALUControlD;
input wire [4:0] RsD,RtD,RdD,ShamtD;
input wire [31:0] ReadData1,ReadData2,SignImmD,PCPlus4D;
output reg RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE,LinkE;
output reg[2:0] ALUControlE;
output reg[4:0] RsE,RtE,RdE,ShamtE;
output reg[31:0] ReadData1E,ReadData2E,SignImmE,PCPlus4E;
always @(posedge clk)
begin
    RegWriteE <= RegWriteD;
    MemtoRegE <= MemtoRegD;
    MemWriteE <= MemWriteD;
    ALUSrcE <= ALUSrcD;
    RegDstE <= RegDstD;
    BranchE <-= BranchD;
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
end
endmodule //id_ex_reg
