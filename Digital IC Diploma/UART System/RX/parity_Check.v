module parity_Check (
		input wire 			PAR_TYP,		//input parity type
		input wire 			par_chk_en,		// Block Enable
		input wire 			sampled_bit,	// sampled bit	
		input wire [7:0]  	P_DATA,			// parall data
	
		output reg			 par_err		// parity error Active LOW
);

always @(*)
	begin
		if(par_chk_en)
			begin
				if(PAR_TYP)
					begin
						par_err = (^P_DATA == sampled_bit) ? 1'b1:1'b0 ;	//Odd  		
					end
				else
					begin
						par_err = (^P_DATA == sampled_bit) ? 1'b1:1'b0 ;	//Eveen	
					end
			end
		else
			begin
				par_err = par_err ;
			end
	end

endmodule

