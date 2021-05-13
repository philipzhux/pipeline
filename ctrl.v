module JBControl(OP,Funct,equalFlag,JBFlag);
input [5:0] OP,Funct;
input equalFlag;
output reg[1:0] JBFlag;
 parameter R_Type = 6'b000000;
 parameter J = 6'b000010;
 parameter JAL = 6'b000011;
 parameter BEQ = 6'b000100;
 parameter BNE = 6'b000101;
 parameter JR = 6'b001000;
always @ (*) begin
  if ((OP==BNE && ~equalFlag) || (OP==BEQ && equalFlag)) JBFlag<=2'b01;
  else if ((OP == J) || (OP == JAL) || ((OP == R_Type) && (Funct == JR))) JBFlag<=2'b10;
  else JBFlag <= 2'b00;
end
endmodule

module JumpMux(OP,Funct,JRawAddr,PCPlus4,ReadData1,JAddr);
input [5:0] OP,Funct;
input [25:0] JRawAddr;
input [31:0] PCPlus4,ReadData1;
output reg [31:0] JAddr;
parameter J = 6'b000010;
parameter JAL = 6'b000011;
always @ (*) begin
  if((OP == J) || (OP == JAL)) JAddr<={PCPlus4[31:28],JRawAddr,2'b00};
  else JAddr<=ReadData1;
end
endmodule

module LinkControl(OP,Link);
parameter JAL = 6'b000011;
input [5:0] OP;
output Link;
assign Link = (OP==JAL)?1'b1:1'b0;
endmodule
module ControlUnit(reset,CtlMux,op,funct,RegWrite,MemtoReg,Branch,ALUControl,ALUSrc,RegDst,MemWrite,invalidRt);
parameter R=6'b000000;
parameter STOP = 6'b111111;
parameter lw=6'b100011;
parameter sw=6'b101011;
parameter beq=6'b000100;
parameter addi = 6'b001000; 
parameter andi = 6'b001100; 
parameter ori = 6'b001101;
parameter slti = 6'b001010;
parameter xori = 6'b001110;
//funct below
parameter addx = 6'b100000;
parameter addux = 6'b100001;
parameter subx = 6'b100010;
parameter subux = 6'b100011;
parameter andx = 6'b100100;
parameter norx = 6'b100111;
parameter orx = 6'b100101;
parameter xorx = 6'b100110;
parameter sllx = 6'b000000;
parameter sllvx = 6'b000100;
parameter srlx = 6'b000010;
parameter srlvx = 6'b000110;
parameter srax = 6'b000011;
parameter sravx = 6'b000111;
parameter sltx = 6'b101010;
parameter jrx = 6'b001000; 
  //alu code
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
parameter XOR = 4'b1101;
//func
parameter J = 6'b000010;
parameter JAL = 6'b000011;
parameter BEQ = 6'b000100;
parameter BNE = 6'b000101;
parameter JR = 6'b001000;
input wire[5:0] op,funct;
input reset;
input CtlMux;
output reg RegDst,Branch,MemtoReg,MemWrite,ALUSrc,RegWrite,invalidRt;
output reg [3:0] ALUControl;

  always @(*)
  begin
if(reset==1) begin
    RegDst <= 1'b0;
   Branch <= 1'b0;
   MemtoReg <= 1'b0;
   ALUControl <= 4'b0000;
   MemWrite <= 1'b0;
   ALUSrc <= 1'b0;
   RegWrite <= 1'b0;
   invalidRt <= 1'b0;
end
  end

  always@(*)
    begin
    if(CtlMux==1'b1)
    begin
        RegDst <= 1'b0;
        Branch <= 1'b0;
        MemtoReg <= 1'b0;
        ALUControl <= 4'b0000;
        MemWrite <= 1'b0;
        ALUSrc <= 1'b0;
        RegWrite <= 1'b0;
        invalidRt <= 1'b0;
    end
    else begin
        case (op)

        STOP:
    begin
        RegDst <= 1'b0;
        Branch <= 1'b0;
        MemtoReg <= 1'b0;
        ALUControl <= 4'b0000;
        MemWrite <= 1'b0;
        ALUSrc <= 1'b0;
        RegWrite <= 1'b0;
        invalidRt <= 1'b0;
    end

        R:           

          begin
          case (funct)
                addx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= ADD;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                addux: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= ADD;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                subx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= SUB;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                subux: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= SUB;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                andx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= AND;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                norx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= NOR;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                orx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= OR;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                xorx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= XOR;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                sllx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= SLL;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                sllvx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= SLLV;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                srlx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= SRL;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                srlvx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= SRLV;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                srax: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= SRA;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                sravx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= SRAV;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                sltx: begin
                    RegWrite <= 1'b1;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= LESS;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b1;
                    invalidRt <= 1'b0;
                end
                JR: begin
                    RegWrite <= 1'b0;
                    MemtoReg <= 1'b0;
                    MemWrite <= 1'b0;
                    Branch <= 1'b0;
                    ALUControl <= 4'b0000;
                    ALUSrc <= 1'b0;
                    RegDst <= 1'b0;
                    invalidRt <= 1'b1;
                end
          endcase
          end
          
          
        
        lw:           

          begin
          RegDst<=0 ;
          Branch<=0 ;
          MemtoReg<=1 ;
          MemWrite<=0 ;
          ALUSrc<=1 ;
          RegWrite<=1 ;
          ALUControl<=ADD;
          invalidRt <= 1'b1;
          end
         
        
        sw:           

          begin
          //RegDst<=1'bx ;
          Branch<=0 ;
          MemtoReg<=0 ;
          MemWrite<=1 ;
          ALUSrc<=1 ;
          RegWrite<=0 ;
          ALUControl<=ADD ;
          invalidRt <= 1'b1;
          end
          
        beq:           

          begin
          //RegDst<=1'bx ;
          Branch<= 1;
          MemtoReg<=0 ;
          MemWrite<=0 ;
          ALUSrc<=0 ;
          RegWrite<=0 ;
          ALUControl<=4'b0000;
          end

	addi:           

          begin
          RegDst<=0 ;
          Branch<=0 ;
          MemtoReg<=0 ;
          MemWrite<=0 ;
          ALUSrc<=1 ;
          RegWrite<=1 ;
          ALUControl<=ADD;
          invalidRt <= 1'b1;
          end



	andi:           

          begin
          RegDst<=0 ;
          Branch<=0 ;
          MemtoReg<=0 ;
          MemWrite<=0 ;
          ALUSrc<=1 ;
          RegWrite<=1 ;
          ALUControl<=AND;
          invalidRt <= 1'b1;
          end

	ori:           

          begin
          RegDst<=0 ;
          Branch<=0 ;
          MemtoReg<=0 ;
          MemWrite<=0 ;
          ALUSrc<=1 ;
          RegWrite<=1 ;
          ALUControl<=OR;
          invalidRt <= 1'b1;
          end
    	xori:           

          begin
          RegDst<=0 ;
          Branch<=0 ;
          MemtoReg<=0 ;
          MemWrite<=0 ;
          ALUSrc<=1 ;
          RegWrite<=1 ;
          ALUControl<=XOR;
          invalidRt <= 1'b1;
          end

	slti:           

          begin
          RegDst<=0 ;
          Branch<=0 ;
          MemtoReg<=0 ;
          MemWrite<=0 ;
          ALUSrc<=1 ;
          RegWrite<=1 ;
          ALUControl<=LESS;
          invalidRt <= 1'b1;
          end
    J: begin
        RegWrite <= 1'b0;
        MemtoReg <= 1'b0;
        MemWrite <= 1'b0;
        Branch <= 1'b0;
        ALUControl <= 4'b0000;
        ALUSrc <= 1'b0;
        RegDst <= 1'b0;
        invalidRt <= 1'b1;
    end
    JAL: begin
        RegWrite <= 1'b1;
        MemtoReg <= 1'b0;
        MemWrite <= 1'b0;
        Branch <= 1'b0;
        ALUControl <= 4'b0000;
        ALUSrc <= 1'b0;
        RegDst <= 1'b0;
        invalidRt <= 1'b1;
    end
    // default: begin
    //     RegDst <= 1'b0;
    //     Branch <= 1'b0;
    //     MemtoReg <= 1'b0;
    //     ALUControl <= 4'b0000;
    //     MemWrite <= 1'b0;
    //     ALUSrc <= 1'b0;
    //     RegWrite <= 1'b0;
    //     invalidRt <= 1'b0;
    // end
      endcase
    end
    end
endmodule

