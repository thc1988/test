// UC Berkeley CS150
// Lab 3, Spring 2012
// Module: ALU.v
// Desc:   32-bit ALU for the MIPS150 Processor
// Inputs: A: 32-bit value
// B: 32-bit value
// ALUop: Selects the ALU's operation 
// 						
// Outputs:
// Out: The chosen function mapped to A and B.

`include "Opcode.vh"
`include "ALUop.vh"

module ALU(
    input [31:0] A,B,
    input [3:0] ALUop,
    output reg [31:0] Out
);

    // Implement your ALU here, then delete this comment
	always @ (*) 
		case(ALUop)
			`ALU_ADDU: Out = A + B;
			`ALU_SUBU: Out = A - B;
			`ALU_SLT: Out = ($signed(A) < $signed(B));
			`ALU_SLTU: Out = A < B;
			`ALU_AND: Out = A & B;
			`ALU_OR: Out = A | B;
			`ALU_XOR: Out = A ^ B;
			`ALU_LUI: Out = {B,16'b0};
			`ALU_SLL: Out = B << A;
			`ALU_SRL: Out = B >> A;
			`ALU_SRA: Out = $signed (B) >>> A;
			`ALU_NOR: Out = ~A & ~B;
			`ALU_XXX: Out = 32'hxxxxxxxx;
		default : Out = 32'hxxxxxxxx;
		endcase
endmodule
