module MUX(	
	input wire 			ser_data,	//	
	input wire 			par_bit,	//
	input wire 			start_bit,	//
	input wire 			stop_bit,	//
	input wire [3:0]	mux_sel,	//
	
	output reg 			TX_OUT  	//OUTPUT serializer DATA
);

always @(*)
	begin
		case(mux_sel)
			3'b000 :
				begin
					TX_OUT = stop_bit ;
				end
			3'b001 :
				begin
					TX_OUT = start_bit ;
				end
			3'b011 :
				begin
					TX_OUT = ser_data ;
				end
			3'b010 :
				begin
					TX_OUT = par_bit ;
				end
			3'b110 :
				begin
					TX_OUT = stop_bit ;
				end
			default :
				begin
					TX_OUT = stop_bit ;
				end
		endcase
	end

endmodule