module Mem_WB_Reg(clk,RegWriteM,MemtoRegM,WriteRegM,RD,ALUOutM,LinkM,MEM_PCPlus4,RegWriteW,MemtoRegW,
WriteRegW,ReadDataW,ALUOutW,LinkW,RB_PCPlus4)
input clk,RegWriteM,MemtoRegM,LinkM;
input wire[4:0] WriteRegM;
input wire[31:0] RD,ALUOutM,MEM_PCPlus4;
output reg RegWriteW,MemtoRegW,LinkW;
output reg[4:0] WriteRegW;
input reg[31:0] ReadDataW,ALUOutW,RB_PCPlus4;
always @ (posedge clk)
begin
    RegWriteW<=RegWriteM;
    MemtoRegW<=MemtoRegM;
    WriteRegW<=WriteRegM;
    ReadDataW<=RD;
    ALUOutW<=ALUOutM;
    LinkW<=LinkM;
    RB_PCPlus4<=MEM_PCPlus4;
end
endmodule //mem_wb_reg