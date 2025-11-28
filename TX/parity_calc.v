module parity_calc(
	input wire 			DATA_VALID		,		//	
	input wire 			PAR_TYP			,		//
	input wire [7:0]	P_DATA			,		//
	
	output reg 			par_bit  				//
);


always @(*)
	begin
		if(PAR_TYP && DATA_VALID)
			begin
			par_bit = ^P_DATA;
			end
		else
			begin
			par_bit = ~(^P_DATA);
			end
	end


endmodule