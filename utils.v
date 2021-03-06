module Add (in1,in2,out);
input wire signed [31:0] in1, in2;
output wire [31:0] out;
assign out = in1 + in2;
endmodule //add

module StopControl(instr,stop);
input [31:0] instr;
output reg stop;
always @(*) stop <= (instr == 32'hffffffff) ? 1'b1 : 1'b0;
endmodule

module ShiftLeftBy2(in,out);
input [31:0] in;
output [31:0] out;
assign out = in << 2;
endmodule

module SignExt(in,out,op);
parameter andi = 6'b001100; 
parameter ori = 6'b001101;
parameter xori = 6'b001110;
input [5:0] op;
input  [15:0] in;
output [31:0] out;
assign out = (op===andi||op===ori||op===xori)?{{16{1'b0}}, in}:{{16{in[15]}}, in};
endmodule

module Comparator(input [31:0] in1,input [31:0] in2,output equal);
assign equal = (in1 == in2) ? 1'b1 : 1'b0;
endmodule

module Parser(input [31:0] in,output [5:0] op,output [5:0] funct,output [4:0] rs,output [4:0] rt,output [4:0] rd,output [4:0] shamt,output[15:0] imm,output[25:0] jaddress);
assign op = in[31:26];
assign funct = in[5:0];
assign rs = in[25:21];
assign rt = in[20:16];
assign rd = in[15:11];
assign shamt = in[10:6];
assign imm = in[15:0];
assign jaddress = in[25:0];
endmodule