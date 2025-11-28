module edge_bit_counter (
		input wire 			CLK,		// System CLK	
		input wire			RST,		// System RST
		input wire 			enable,		// Block Enable
		input wire [5:0]	Prescale,	// input sampling rate
	
		output reg [5:0]	edge_cnt,	// Number of the current CLK edge
		output reg [3:0] 	bit_cnt		// Number of the current input bit
);

always @(posedge CLK or negedge RST)
	begin
		if(!RST)
			begin
				edge_cnt <= 'd0 ;
				bit_cnt  <= 'd0 ;
			end
		else if (enable)
			begin
				if(edge_cnt != Prescale)
					begin
						edge_cnt <= edge_cnt + 1 ;
					end
				else
					begin
						edge_cnt <= 'd1 ;
					end
				

				
				if(edge_cnt == Prescale)
					begin
						bit_cnt  <= bit_cnt  + 1 ;					
					end
				else
					begin
						bit_cnt <= bit_cnt  ;	
					end
			end
		else
			begin 
				edge_cnt <= 'd0 ;
				bit_cnt  <= 'd0 ;
			end
	end


endmodule

