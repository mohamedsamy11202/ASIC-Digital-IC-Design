module UART_RX(
	input wire 			CLK_RX,			//System CLK
	input wire 			RST_RX,			//System RST
	input wire 			RX_IN,			//input serial data
	input wire [5:0]	Prescale,		//input sampling rate
	input wire 			PAR_EN,			//input parity enable
	input wire 			PAR_TYP,		//input parity type
	
	output wire [7:0]	P_DATA,			//output parall data
	output wire 		Parity_error,  	//output parity error detected
	output wire 		Stop_Error,		//output stop bit error detected	
	output wire 		data_valid		//output data is ready
);

wire [5:0]edge_cnt_RX ;
wire [3:0]bit_cnt_RX ;

wire par_err_RX , strt_glitch_RX , stp_err_RX ;

wire dat_samp_en_RX , enable_RX , deser_en_RX ,stp_chk_en_RX  , strt_chk_en_RX , par_chk_en_RX ;

wire sampled_bit_RX ;

FSM FSM_DUT(
	.CLK(CLK_RX),
	.RST(RST_RX),
	.RX_IN(RX_IN),
	.PAR_EN(PAR_EN),
	.edge_cnt(edge_cnt_RX),
	.bit_cnt(bit_cnt_RX),
	.par_err(par_err_RX),
	.strt_glitch(strt_glitch_RX),
	.stp_err(stp_err_RX),
	.Prescale(Prescale),
	
	.dat_samp_en(dat_samp_en_RX),
	.enable(enable_RX),
	.deser_en(deser_en_RX),
	.stp_chk_en(stp_chk_en_RX),
	.strt_chk_en(strt_chk_en_RX),
	.par_chk_en(par_chk_en_RX),
	.Stop_Error(Stop_Error),
	.Parity_error(Parity_error)
);

parity_Check parity_Check_DUT(
	.PAR_TYP(PAR_TYP),
	.par_chk_en(par_chk_en_RX),
	.sampled_bit(sampled_bit_RX),
	.P_DATA(P_DATA),
	
	.par_err(par_err_RX)
);

deserializer deserializer_DUT(
	.CLK(CLK_RX),
	.RST(RST_RX),
	.deser_en(deser_en_RX),
	.sampled_bit(sampled_bit_RX),

	.data_valid(data_valid),
	.P_DATA(P_DATA)
);

edge_bit_counter edge_bit_counter_DUT(
	.CLK(CLK_RX),
	.RST(RST_RX),
	.enable(enable_RX),
	.Prescale(Prescale),
	
	.edge_cnt(edge_cnt_RX),
	.bit_cnt(bit_cnt_RX)
	
);

data_sampling data_sampling_DUT(
	.CLK(CLK_RX),
	.RST(RST_RX),
	.RX_IN(RX_IN),
	.Prescale(Prescale),
	.dat_samp_en(dat_samp_en_RX),
	.edge_cnt(edge_cnt_RX),
	
	.sampled_bit(sampled_bit_RX)

);

start_check start_check_DUT(
	.strt_chk_en(strt_chk_en_RX),
	.sampled_bit(sampled_bit_RX),
	
	.strt_glitch(strt_glitch_RX)
);

stop_check stop_check_DUT(
	.stp_chk_en(stp_chk_en_RX),
	.sampled_bit(sampled_bit_RX),
	
	.stp_err(stp_err_RX)
);


endmodule
