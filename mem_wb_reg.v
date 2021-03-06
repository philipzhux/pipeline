module Mem_RB_Reg(clk,RegWriteM,MemtoRegM,WriteRegM,RD,ALUOutM,LinkM,MEM_PCPlus4,MEM_Instr,RegWriteW,MemtoRegW,
WriteRegW,ReadDataW,ALUOutW,LinkW,RB_PCPlus4,RB_Instr);
input clk,RegWriteM,MemtoRegM,LinkM;
input wire[4:0] WriteRegM;
input wire[31:0] RD,ALUOutM,MEM_PCPlus4,MEM_Instr;
output reg[31:0] ReadDataW,ALUOutW,RB_PCPlus4,RB_Instr;
output reg RegWriteW,MemtoRegW,LinkW;
output reg[4:0] WriteRegW;
always @ (posedge clk)
begin
    RegWriteW<=RegWriteM;
    MemtoRegW<=MemtoRegM;
    WriteRegW<=WriteRegM;
    ReadDataW<=RD;
    ALUOutW<=ALUOutM;
    LinkW<=LinkM;
    RB_PCPlus4<=MEM_PCPlus4;
    RB_Instr<=MEM_Instr;
end
endmodule //mem_wb_reg