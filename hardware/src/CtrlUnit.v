module CtrlUnit(input [5:0] Op,fucnt,
		input [4:0] rt,
		output reg MemtoReg, //done
			   MemWrite, //done
			   ALUSrc, //done
			   RegDst, //done
			   RegWrite, //done
	 		   shamt?, //done
		output	   beq, //done
			   bne, //done
			   BGEZ, //done
			   BLEZ, //done
			   BGTZ, //done
			   BLTZ, //done
			   J, //done
			   JAL, //done
			   JR, //done
			   JALR, //done
		output reg sign?, //done
		output	   jump?, //done
			   LH?, //done
			   LB?, //done
			   LHU?, //done
			   LBU?, //done
			   SB?, //done
			   SH?, //done
		output [2:0] ALUop,//done
		output reg [1:0] store?);//done
// ALUop
ALUdec ALUdecoder( .funct(funct), .opcode(Op), .ALUop(ALUop) );
//MemtoReg
always @(*) 
	case(Op)
	`LB, `LH, `LW, `LBU, `LHU: MemtoReg=1;
	default: MemtoReg=0;
	endcase
//MemWrite
always @(*)
	case(Op)
	`SB, `SW, `SH: MemWrite=1;
	default: MemWrite =0;
	endcase

//store?
always @(*)
	case(Op)
	`SW: store? = 2'b00;
	`SH: store? = 2'b10;
	`SB; store? = 2'b01;
	default: store? = 2'b11;
	endcase

//ALUSrc
always @(*)
	case(Op)
	`ADDIU, `SLTI, `SLTIU, `ANDI, `ORI, `XORI, `LUI: ALUSrc=1;
	`SW, `SB, `SH: ALUSrc=1;
	`LB, `LH, `LBU, `LHU, `LW: ALUSrc=1;
	default: ALUSrc =0;
	endcase
		
//RegDst
always @(*)
	case(Op)
	`RTYPE: RegDst = 1;
	default: RegDst =0;
	endcase

//RegWrite
always @(*)
	case(Op)
	`RTYPE: if(funct==6'b001000)RegWrite=0; //JR
		else RegWrite =1;
	6'b000011 = RegWrite=1; //JAL
	`ADDIU, `SLTI, `SLTIU, `ANDI, `ORI, `XORI, `LUI: RegWrite=1;
	`LB, `LH, `LBU, `LHU, `LW: RegWrite=1;
	default: RegWrite =0;
	endcase
//shamt?
always @(*)
	case(Op)
	`SLL, `SRL, `SRA: shamt? = 1;
	default: shamt? =0;
	endcase
//beq
assign beq = (Op == 6'b000100);
//bne
assign bne = (Op == 6'b000101);
//BLEZ, BGTZ, BLTZ, BGEZ
assign BLEZ = (Op == 6'b000110);
assign BGTZ = (Op == 6'b000111);
assign BLTZ = ((Op == 6'b000001) && (rt == 5'b00000));
assign BGEZ = ((Op == 6'b000001) && (rt == 5'b00001));
//J
assign J = (Op == 6'b000010);
//JAL
assign JAL= (Op == 6'b000011);
//JR , JALR
assign JR = ((Op == `RTYPE) && (funct==6'b001000));
assign JALR = ((Op == `RTYPE) && (funct==6'b001001));
//sign?
always @(*)
	case(Op)
	`LB, `LH, `LW, `LBU, `LHU, `SB, `SH, `SW: sign?=1;
	`ADDIU, `SLTI, `SLTIU: sign?=1;
	default: sign?=0;
	endcase
//jump?
assign	jump? = (J||JAL||JR||JALR);

//LH?,LB?,LHU?,LBU?
assign LH?= (Op == `LH);
assign LB?= (Op == `LB);
assign LHU?= (Op == `LHU);
assign LBU?= (Op == `LBU);

//SB?,SH?
assign SB?= (Op ==`SB);
assign SH?= (Op ==`SH);


endmodule