module ALU32(in1, in2, ALUControl, shamt, res);

input wire reset;
input wire signed [31:0] in1,in2;
input wire [3:0] ALUControl;
input wire [4:0] shamt;
output reg signed [31:0] res;

wire [31:0] neg_in2;
assign neg_in2 = ~in2+1;
parameter ADD = 4'b0001;
parameter AND = 4'b0010;
parameter OR = 4'b0011;
parameter SUB = 4'b0100;
parameter SLL = 4'b0101;
parameter SRL = 4'b0110;
parameter SRA = 4'b0111;
parameter LESS = 4'b1000;
parameter NOR = 4'b1001;
parameter SLLV = 4'b1010;
parameter SRLV = 4'b1011;
parameter SRAV = 4'b1100;

always @(ALUControl, in1, in2)
begin
case(ALUControl)
ADD: 
	res <= in1 + in2;
AND:
	res <= in1 & in2;

OR:
	res <= in1 | in2;
SUB:
    res <= in1 + neg_in2;
SLL:
	res <= in1 << shamt;
SLLV:
	res <= in1 << in2;
SRL:
	res <= in1 >> shamt;
SRLV:
	res <= in1 >> in2;
SRA:
	res <= $signed(in1) >>> shamt;
SRA:
	res <= $signed(in1) >>> in2;
LESS:
	begin
	if(in1 < in2)
	res <= 1;
	else
	res <= 0;
	end
NOR:
	begin
	res <= ~(in1 | in2);
	end
endcase
end

endmodule
