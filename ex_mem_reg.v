module EX_MEM_Reg(clk,RegWriteE,MemtoRegE,MemWriteE,WriteRegE,EX_ALUOut,EX_WriteData,EX_Link,EX_PCPlus4,EX_Instr,
RegWriteM,MemtoRegM,MemWriteM,WriteRegM,MEM_ALUOut,MEM_WriteData,MEM_Link,MEM_PCPlus4,MEM_Instr);
    input clk,RegWriteE,MemtoRegE,MemWriteE,EX_Link;
    input wire[4:0] WriteRegE;
    input wire[31:0] EX_ALUOut,EX_WriteData,EX_PCPlus4,EX_Instr;
    output reg RegWriteM,MemtoRegM,MemWriteM,MEM_Link;
    output reg[4:0] WriteRegM;
    output reg[31:0] MEM_ALUOut,MEM_WriteData,MEM_PCPlus4,MEM_Instr;
always @ (posedge clk)
begin
    RegWriteM<=RegWriteE;
    MemtoRegM<=MemtoRegE;
    MemWriteM<=MemWriteE;
    WriteRegM<=WriteRegE;
    MEM_ALUOut<=EX_ALUOut;
    MEM_WriteData<=EX_WriteData;
    MEM_Link<=EX_Link;
    MEM_PCPlus4 <= EX_PCPlus4;
    MEM_Instr <= EX_Instr;

end
endmodule //ex_mem_reg