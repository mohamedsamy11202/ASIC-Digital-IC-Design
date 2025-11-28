module data_sampling (
		input wire 			CLK,			// System CLK
		input wire 			RST,			// System RST
		input wire 			dat_samp_en,	// Block Enable	
		input wire 			RX_IN,			// input serial data
		input wire [5:0]	Prescale,		// input sampling rate		
		input wire [5:0]	edge_cnt,		// Number of the current edge
	
		output reg 			sampled_bit		// output sampled bit
);

reg sample1, sample2, sample3;

wire [5:0] SAMPLE_MID = Prescale >> 1;  // divide by 2

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		sample1      <= 1'b0;
		sample2      <= 1'b0;
		sample3      <= 1'b0;
		sampled_bit  <= 1'b0;
	end 
	else if (dat_samp_en) begin
		if (edge_cnt == (SAMPLE_MID - 'd1)) 
			begin
				sample1 <= RX_IN;  				// before middle
			end
		else if (edge_cnt == SAMPLE_MID)  
			begin
				sample2 <= RX_IN;  				// middle
			end
		else if (edge_cnt == (SAMPLE_MID + 'd1))
			begin
				sample3 <= RX_IN; 				// after middle
			end	
		else if (edge_cnt == (SAMPLE_MID + 'd2)) 
		begin
			sampled_bit <= (sample1 & sample2) | (sample2 & sample3) | (sample1 & sample3);
		end
	end
end
	
endmodule

