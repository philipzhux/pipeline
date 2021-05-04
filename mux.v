module Mux2x5(signal,in1,in2,out);
input signal;
input [4:0] in1, in2;
output [4:0] out;
assign out=(signal == 1'b0)?in1:(signal == 1'b1)?in2:5'bx;
endmodule
module Mux2x32(signal,in1,in2,out);
input signal;
input [31:0] in1, in2;
output [31:0] out;
assign out=(signal == 1'b0)?in1:(signal == 1'b1)?in2:32'bx;
endmodule
module Mux3x32(signal,in1,in2,in3,out);
input signal;
input [31:0] in1, in2;
output [31:0] out;
assign out=(signal == 2'b00)?in1:(signal == 2'b01)?in2:(signal == 2'b10)?in3:32'bx;
endmodule