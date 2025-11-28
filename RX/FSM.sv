module FSM(
	input wire 			CLK,			// System CLK	
	input wire 			RST,			// System RST
	input wire 			RX_IN,			//input serial data
	input wire 			PAR_EN,			//input parity enable
	input wire [5:0]	edge_cnt,		// Number of the current CLK edge
	input wire [3:0]	bit_cnt,		// Number of the current input bit
	input wire 			par_err,		// parity error Active LOW
	input wire 			strt_glitch,	// start glitch Active high 
	input wire 			stp_err,		// stop error Active low 
	input wire [5:0]	Prescale,		// input sampling rate
	
	output reg 			dat_samp_en, 	// output Enamble to sample input data 
	output reg 			enable,			// output Enamble to start count 
	output reg 			deser_en,		// output Enamble to start deserializing 
	output reg 			stp_chk_en,		// output Enamble to check start bit
	output reg 			strt_chk_en,	// output Enamble to check stop bit 
	output reg 			par_chk_en,		// output Enamble to check parity bit
	output reg 			Parity_error,	//output parity error detected
	output reg 			Stop_Error		//output stop bit error detected 
);

typedef enum bit [2:0]{
		IDLE	= 3'b000,
		DATA	= 3'b001,
		PARITY	= 3'b011,
		STOP	= 3'b010
}state;
			
state current_state , next_state;		

wire [5:0] MID = Prescale >> 1;  // divide by 2


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
					if(strt_glitch && edge_cnt == (MID + 'd2))
						begin
						next_state = DATA ;
						end
					else
						begin
						next_state = IDLE ;
						end
				end
			DATA :
				begin
					if(bit_cnt != 'd9)
						begin
							next_state = DATA;
						end
					else if(PAR_EN)
						begin
							next_state = PARITY;
						end		
					else
						begin
							next_state =  STOP;
						end
				end
			PARITY :
				begin
					if(par_err && edge_cnt == MID + 'd2)
						begin
							next_state = STOP;
							Parity_error = 'b0 ;
						end
					else if(!par_err && edge_cnt == MID + 'd2)
						begin
							next_state = IDLE ;
							Parity_error = 'b1 ;
						end
				end
			STOP :
				begin
					if(edge_cnt == MID + 'd2 && !stp_err)
						begin
							next_state = IDLE;
							Stop_Error = 'b0 ;
						end	
					else if(edge_cnt == MID + 'd2 && stp_err)	
						begin
							Stop_Error = 'b1 ;
							next_state = IDLE;
						end
				end
			default :
				begin
					next_state = IDLE;
				end	
		endcase
	end
	
// output logic	
always @(*)
	begin
		dat_samp_en = 'b1;
		enable 		= 'b1;
		deser_en 	= 'b0;
		strt_chk_en = 'b0;
		stp_chk_en 	= 'b0;
		par_chk_en 	= 'b0;
		Stop_Error  = 'b0;
		Parity_error= 'b0;
		
		case(current_state)
			IDLE :
				begin 
					if(!RX_IN)
							begin							
							dat_samp_en = 'b1;
							enable		= 'b1;	
						end
					else
						begin
							dat_samp_en = 'b0;
							enable 		= 'b0;
						end
					
					if(edge_cnt == MID + 'd1)
						begin
							strt_chk_en = 'b1;													
						end
					else
						begin
							strt_chk_en = 'b0;		
						end					
				end			
			DATA :
				begin
					if(edge_cnt == MID + 'd3)
						begin
							deser_en = 'b1;
						end
					else
						begin
							deser_en = 'b0;
						end
				end
			PARITY :
				begin
					if(edge_cnt == MID + 'd1)
						begin
							par_chk_en = 'b1 ;
						end
					else
						begin
							par_chk_en = 'b0  ;
						end
				end
			STOP :
				begin
					if(edge_cnt == MID + 'd2)
						begin
							stp_chk_en = 'b1;													
						end
					else
						begin
							stp_chk_en = 'b0;		
						end											
				end
			default :
				begin
					dat_samp_en = 'b0;
					enable 		= 'b0;
					deser_en 	= 'b0;
					stp_chk_en 	= 'b0;
					par_chk_en 	= 'b0;
					Stop_Error  = 'b0;
					Parity_error= 'b0;
				end
		endcase
	end	

endmodule

