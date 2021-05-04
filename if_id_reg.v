module IF_ID_Reg(clk,PCPlus4F,InstrF,IF_Stall,IF_Flush,PCPlus4D,InstrD);

  input wire [31:0] InstrF,PCPlus4F;
  input clk,IF_Stall,IF_Flush;
  output reg [31:0] InstrD, PCPlus4D;

  always @(posedge clk)
    begin
    if (IF_hold==1'b0) 
    begin
        if (IF_Flush==1'b1)
        begin
            PCPlus4D<=PCPlus4F; 
            InstrF<=32'b0;
        end
        else begin
            PCPlus4D<=PCPlus4F;
            InstrF <= instrIn; 
        end    
    end
    end
endmodule //if_id_reg
