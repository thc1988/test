module UATransmit(
  input   Clock,
  input   Reset,

  input   [7:0] DataIn,
  input         DataInValid,
  output        DataInReady,
  output        SOut
);
  // for log2 function
  `include "util.vh"

  //--|Parameters|--------------------------------------------------------------

  parameter   ClockFreq         =   100_000_000;
  parameter   BaudRate          =   115_200;

  // See diagram in the lab guide
  localparam  SymbolEdgeTime    =   ClockFreq / BaudRate;
  localparam  ClockCounterWidth =   log2(SymbolEdgeTime);

  //--|Solution|----------------------------------------------------------------

//Declarations---------------------------------------

	wire	SymbolEdge;
	wire 	Start;
	wire	TXRunning;
	
	reg	[3:0]	BitCounter;
	reg	[9:0] TXShift;
	reg	[ClockCounterWidth-1 :0]	ClockCounter;
	reg	HasByte;

//Signal Assignments----------------------------------
	//Goes high at every symbol edge
	assign SymbolEdge = (ClockCounter == SymbolEdgeTime - 1);

	//Goes high when it is to start transmitting a new character
	assign Start = !SOut && !TXRunning;
	
	//Current transmiting a character
	assign TXRunning = BitCounter != 4'd0;

	//Outputs
	assign DataInReady = HasByte && !TXRunning;
	assign SOut = TXShift[0];

	//shift resigster
	always @ (posedge Clock) begin
		if (Reset) begin
			TXShift[0] <= 1'b1;
		end else if (DataInValid && DataInReady) begin
			TXShift <= {1'b1, DataIn, 1'b0};
		end else if (SymbolEdge && TXRunning && BitCounter >= 2) begin
			TXShift <= TXShift >> 1;
		end
		end

//Counters----------------------------------------------

	//Counts cycles until a single symbol is done
	always @ (posedge Clock) begin
		ClockCounter <= (Start || Reset || SymbolEdge) ? 0 : ClockCounter +1;
		end

	//Counters down from 10 bits for every character
	always @ (posedge Clock) begin
		if(Reset) begin
			BitCounter <= 0;
		end else if(Start) begin
			BitCounter <= 10;
		end else if(SymbolEdge && TXRunning) begin
			BitCounter <= BitCounter - 1;
		end
		end



//Extra State fpr Ready/Valid-----------------------------

	always @ (posedge Clock) begin
		if (Reset) HasByte <= 1'b1;
		else if (BitCounter == 1 && SymbolEdge) HasByte <= 1'b1;
		else if (DataInValid) HasByte <=1'b0;
	end
	


endmodule
