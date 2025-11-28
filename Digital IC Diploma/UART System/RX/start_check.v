module start_check (
		input wire strt_chk_en, 	// Block Enable
		input wire sampled_bit,		// input sampled bit
	
		output reg strt_glitch		// start glitch Active high 
);


always @(*)
	begin
		if(strt_chk_en && sampled_bit)
			begin
				strt_glitch = 1'b0 ;   		
			end
		else
			begin
				strt_glitch = 1'b1 ;		
			end
	end

endmodule

