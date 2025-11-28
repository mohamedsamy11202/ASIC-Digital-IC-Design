module deserializer (
	input wire 		  	CLK,			// System CLK
    input wire 		  	RST,			// System RST
	input  wire       	deser_en,		// Block Enable
    input  wire       	sampled_bit,	// sampled bit
	
    output wire 		data_valid ,	//output data is ready
	output wire  [7:0] 	P_DATA			//output parall data
);

reg [7:0] shift_reg;
reg [3:0] counter;

assign P_DATA  	   = (counter == 4'd9) ? shift_reg : P_DATA;
assign data_valid  = (counter == 4'd9) ? 1'd1 : 1'd0;

always @(posedge CLK or negedge RST)
	begin
		if(!RST)
			begin
				shift_reg   <= 8'd0;
				counter     <= 4'd0;
			end	
		else
			begin
				shift_reg   = shift_reg;
				counter     = counter;
			end
	end

always @(*) 
	begin
		if (deser_en) 
			begin					
				if(counter != 4'd9)
					begin
						shift_reg = {sampled_bit, shift_reg[7:1]};
						counter   = counter + 1;					
					end	
				else
					begin
						shift_reg   = 8'd0;
						counter     = 4'd0;
					end	
			end		
		else if(!deser_en && counter == 4'd9) 
			begin
				shift_reg   = 8'd0;
				counter     = 4'd0;
			end
		else
			begin
				shift_reg   = shift_reg;
				counter     = counter;
			end
	end
endmodule
