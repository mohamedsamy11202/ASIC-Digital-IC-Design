module UART_TX(
	input wire CLK_TX,			//System CLK
	input wire RST_TX,			//System RST
	input wire PAR_TYP_TX,		//parity Type
	input wire PAR_EN_TX,		//Enable	
	input wire DATA_VALID_TX,	//Input DATA VALID
	input wire [7:0]P_DATA_TX,	//Input DATA
	
	output wire Busy_TX,			//Block is Busy
	output wire TX_OUT_TX  		//OUTPUT serializer DATA
);



wire SER_DONE , SER_EN , PAR_BIT , SER_DATA; 
wire [3:0] MUX_SEL;

FSM FSM_DUT(
	.CLK(CLK_TX),
	.RST(RST_TX),
	.DATA_VALID(DATA_VALID_TX),
	.PAR_EN(PAR_EN_TX),
	.ser_done(SER_DONE),
	
	.ser_en(SER_EN),
	.mux_sel(MUX_SEL),
	.Busy(Busy_TX)
);

parity_calc parity_calc_DUT(
	.P_DATA(P_DATA_TX),
	.DATA_VALID(DATA_VALID_TX),
	.PAR_TYP(PAR_TYP_TX),
	
	.par_bit(PAR_BIT)
);

serializer serializer_DUT(
	.CLK(CLK_TX),
	.RST(RST_TX),
	.P_DATA(P_DATA_TX),
	.ser_en(SER_EN),
	
	.ser_done(SER_DONE),
	.ser_data(SER_DATA)
);

MUX MUX_DUT(
	.mux_sel(MUX_SEL),
	.ser_data(SER_DATA),
	.par_bit(PAR_BIT),
	.start_bit(1'b0),
	.stop_bit(1'b1),
	
	.TX_OUT(TX_OUT_TX)
);

endmodule