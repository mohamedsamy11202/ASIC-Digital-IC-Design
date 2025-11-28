module FSM(
	input wire CLK,			//System CLK
	input wire RST,			//System RST
	input wire DATA_VALID,	//
	input wire PAR_EN,		//	
	input wire ser_done,	//

	
	output reg 		 ser_en,	//
	output reg [3:0] mux_sel,  	//
	output reg 		 Busy
);

typedef enum bit [2:0]{
		IDLE	= 3'b000,
		START	= 3'b001,
		DATA	= 3'b011,
		PARITY	= 3'b010,
		STOP	= 3'b110
}state;
			
state current_state , next_state;			


// state transition
always @(posedge CLK or negedge RST)
	begin
		if(!RST)
			begin
				current_state <= IDLE;
			end
		else
			begin
				current_state <= next_state;
			end
	end

// next_state logic
always @(*)
	begin
		case(current_state)
			IDLE :
				begin
					if(DATA_VALID && !Busy)
						begin
							next_state <= START;
						end
					else
						begin
							next_state <= IDLE;
						end
				end
			START :
				begin
					if(CLK)
						begin
							next_state <= START;
							
						end
					else
						begin
							next_state <= DATA;
							
						end
				end
			DATA :
				begin
					if(!ser_done)
						begin
							next_state <= DATA;
						end
					else if(PAR_EN)
						begin
							next_state <= PARITY;
						end
					else
						begin
							next_state <= STOP;
						end
				end
			PARITY :
				begin
					if(CLK)
						begin
							next_state <= PARITY;
						end
					else
						begin
							next_state <= STOP;
						end
				end
			STOP :
				begin
					if(CLK)
						begin
							next_state <= STOP;
						end
					else
						begin
							next_state <= IDLE;
						end
				end
			default :
				begin
					next_state <= IDLE;
				end	
		endcase
	end
	
// output logic	
always @(*)
	begin
		mux_sel = 3'b000;
		Busy    = 1'b1;
		ser_en  = 1'b0; 
		case(current_state)
			IDLE :
				begin 
					Busy    = 1'b0;
					mux_sel = 3'b000;
				end
			START :
				begin					
					mux_sel = 3'b001;
					if(DATA_VALID)
						begin
							ser_en  = 1'b1;
						end
					else
						begin
							ser_en  = 1'b0;
						end
				end
			DATA :
				begin
					mux_sel = 3'b011;
				end
			PARITY :
				begin
					mux_sel = 3'b010;
				end
			STOP :
				begin
					mux_sel = 3'b110;
				end
			default :
				begin
					mux_sel = 3'b000;
					Busy    = 1'b1;
					ser_en  = 1'b0;
				end
		endcase
	end	

endmodule