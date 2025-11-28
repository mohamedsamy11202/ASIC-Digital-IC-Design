module stop_check (		
		input wire stp_chk_en,		// Block Enable
		input wire sampled_bit,		// input sampled bit
	
		output reg stp_err			// stop error Active low 
		 
);

always @(*)
	begin
		if(stp_chk_en && sampled_bit)
			begin
				stp_err = 1'b0 ;
			end
		else
			begin
				stp_err = 1'b1 ;
			end
	end

endmodule

