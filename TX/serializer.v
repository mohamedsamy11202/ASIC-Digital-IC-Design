module serializer(
	input wire 		 CLK,			//System CLK
	input wire 		 RST,			//System RST
	input wire [7:0] P_DATA,		//
	input wire 		 ser_en,		//Enable
	
	output reg ser_done,  
	output reg  ser_data  		    //OUTPUT serializer DATA
);

reg [7:0] shift_reg ;
reg [3:0] counter = 4'd9;	


always @(posedge CLK or negedge RST)
	begin
		if(!RST)
			begin
				ser_data    <= 1'b0;
				counter[3:0] <= 4'd8;
			end
		else
			begin
				if (counter > 4'b0000) 
					begin
						counter   <= counter - 1;
						ser_data  <= shift_reg[7];
						shift_reg <= {shift_reg[6:0], 1'b0};						
					end
					
				if (counter == 4'b0000)
					begin
						ser_done = 1'b1;
					end
				else
					begin
						ser_done = 1'b0;
					end
			end	
	end

always @(*)
	begin
		if(ser_en)
			begin
				shift_reg[7:0] = P_DATA[7:0] ;
				counter = 4'd8;		
			end
		else
			begin
				shift_reg[7:0] = shift_reg[7:0] ;
				counter = counter;	
			end
	end

endmodule