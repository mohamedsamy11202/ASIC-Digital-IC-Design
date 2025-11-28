onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group RX_TOP /UART_RX_tb/TX_CLK_FREQ
add wave -noupdate -expand -group RX_TOP /UART_RX_tb/RX_CLK_FREQ
add wave -noupdate -expand -group RX_TOP /UART_RX_tb/RX_CLK_PERIOD
add wave -noupdate -expand -group RX_TOP /UART_RX_tb/CLK_RX_tb
add wave -noupdate -expand -group RX_TOP /UART_RX_tb/RST_RX_tb
add wave -noupdate -expand -group RX_TOP -color Cyan /UART_RX_tb/RX_IN_tb
add wave -noupdate -expand -group RX_TOP -color Cyan -radix unsigned /UART_RX_tb/prescale_tb
add wave -noupdate -expand -group RX_TOP -color Gold /UART_RX_tb/PAR_EN_tb
add wave -noupdate -expand -group RX_TOP -color Gold /UART_RX_tb/PAR_TYP_tb
add wave -noupdate -expand -group RX_TOP -color Magenta /UART_RX_tb/P_DATA_tb
add wave -noupdate -expand -group RX_TOP -color Magenta /UART_RX_tb/Parity_error_tb
add wave -noupdate -expand -group RX_TOP -color Magenta /UART_RX_tb/Stop_Error_tb
add wave -noupdate -expand -group RX_TOP -color Magenta /UART_RX_tb/data_valid_tb
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/CLK
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/RST
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/RX_IN
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/PAR_EN
add wave -noupdate -group FSM -color Cyan -radix unsigned /UART_RX_tb/DUT/FSM_DUT/edge_cnt
add wave -noupdate -group FSM -color Cyan -radix unsigned /UART_RX_tb/DUT/FSM_DUT/bit_cnt
add wave -noupdate -group FSM -color Gold /UART_RX_tb/DUT/FSM_DUT/par_err
add wave -noupdate -group FSM -color Gold /UART_RX_tb/DUT/FSM_DUT/strt_glitch
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/stp_err
add wave -noupdate -group FSM -color Cyan -radix unsigned /UART_RX_tb/DUT/FSM_DUT/Prescale
add wave -noupdate -group FSM -color Magenta /UART_RX_tb/DUT/FSM_DUT/dat_samp_en
add wave -noupdate -group FSM -color Magenta /UART_RX_tb/DUT/FSM_DUT/enable
add wave -noupdate -group FSM -color Magenta /UART_RX_tb/DUT/FSM_DUT/deser_en
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/stp_chk_en
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/strt_chk_en
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/par_chk_en
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/Parity_error
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/Stop_Error
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/current_state
add wave -noupdate -group FSM /UART_RX_tb/DUT/FSM_DUT/next_state
add wave -noupdate -group FSM -color Gold /UART_RX_tb/DUT/FSM_DUT/MID
add wave -noupdate -group parity /UART_RX_tb/DUT/parity_Check_DUT/PAR_TYP
add wave -noupdate -group parity /UART_RX_tb/DUT/parity_Check_DUT/par_chk_en
add wave -noupdate -group parity /UART_RX_tb/DUT/parity_Check_DUT/sampled_bit
add wave -noupdate -group parity /UART_RX_tb/DUT/parity_Check_DUT/P_DATA
add wave -noupdate -group parity -color Magenta /UART_RX_tb/DUT/parity_Check_DUT/par_err
add wave -noupdate -group deser /UART_RX_tb/DUT/deserializer_DUT/CLK
add wave -noupdate -group deser /UART_RX_tb/DUT/deserializer_DUT/RST
add wave -noupdate -group deser /UART_RX_tb/DUT/deserializer_DUT/deser_en
add wave -noupdate -group deser /UART_RX_tb/DUT/deserializer_DUT/sampled_bit
add wave -noupdate -group deser -color Magenta /UART_RX_tb/DUT/deserializer_DUT/data_valid
add wave -noupdate -group deser -color Magenta /UART_RX_tb/DUT/deserializer_DUT/P_DATA
add wave -noupdate -group deser -color Gold /UART_RX_tb/DUT/deserializer_DUT/shift_reg
add wave -noupdate -group deser -color Gold -radix unsigned /UART_RX_tb/DUT/deserializer_DUT/counter
add wave -noupdate -group {bit counter} /UART_RX_tb/DUT/edge_bit_counter_DUT/CLK
add wave -noupdate -group {bit counter} /UART_RX_tb/DUT/edge_bit_counter_DUT/RST
add wave -noupdate -group {bit counter} /UART_RX_tb/DUT/edge_bit_counter_DUT/enable
add wave -noupdate -group {bit counter} -color Cyan -radix unsigned /UART_RX_tb/DUT/edge_bit_counter_DUT/Prescale
add wave -noupdate -group {bit counter} -color Magenta -radix unsigned /UART_RX_tb/DUT/edge_bit_counter_DUT/edge_cnt
add wave -noupdate -group {bit counter} -color Magenta -radix unsigned /UART_RX_tb/DUT/edge_bit_counter_DUT/bit_cnt
add wave -noupdate -group {data sampling} /UART_RX_tb/DUT/data_sampling_DUT/CLK
add wave -noupdate -group {data sampling} /UART_RX_tb/DUT/data_sampling_DUT/RST
add wave -noupdate -group {data sampling} /UART_RX_tb/DUT/data_sampling_DUT/dat_samp_en
add wave -noupdate -group {data sampling} /UART_RX_tb/DUT/data_sampling_DUT/RX_IN
add wave -noupdate -group {data sampling} -color Cyan -radix unsigned /UART_RX_tb/DUT/data_sampling_DUT/Prescale
add wave -noupdate -group {data sampling} -color Cyan -radix unsigned /UART_RX_tb/DUT/data_sampling_DUT/edge_cnt
add wave -noupdate -group {data sampling} -color Magenta /UART_RX_tb/DUT/data_sampling_DUT/sampled_bit
add wave -noupdate -group {data sampling} /UART_RX_tb/DUT/data_sampling_DUT/sample1
add wave -noupdate -group {data sampling} /UART_RX_tb/DUT/data_sampling_DUT/sample2
add wave -noupdate -group {data sampling} /UART_RX_tb/DUT/data_sampling_DUT/sample3
add wave -noupdate -group {data sampling} -color Gold -radix unsigned /UART_RX_tb/DUT/data_sampling_DUT/SAMPLE_MID
add wave -noupdate -group start /UART_RX_tb/DUT/start_check_DUT/strt_chk_en
add wave -noupdate -group start /UART_RX_tb/DUT/start_check_DUT/sampled_bit
add wave -noupdate -group start -color Magenta /UART_RX_tb/DUT/start_check_DUT/strt_glitch
add wave -noupdate -group stop /UART_RX_tb/DUT/stop_check_DUT/stp_chk_en
add wave -noupdate -group stop /UART_RX_tb/DUT/stop_check_DUT/sampled_bit
add wave -noupdate -group stop -color Magenta /UART_RX_tb/DUT/stop_check_DUT/stp_err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58501786 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {335815445 ps}
