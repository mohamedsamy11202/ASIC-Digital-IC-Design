onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TOP /UART_TX_tb/CLK_TX_TB
add wave -noupdate -expand -group TOP /UART_TX_tb/RST_TX_TB
add wave -noupdate -expand -group TOP /UART_TX_tb/PAR_TYP_TX_TB
add wave -noupdate -expand -group TOP /UART_TX_tb/PAR_EN_TX_TB
add wave -noupdate -expand -group TOP /UART_TX_tb/DATA_VALID_TX_TB
add wave -noupdate -expand -group TOP /UART_TX_tb/P_DATA_TX_TB
add wave -noupdate -expand -group TOP -color Magenta /UART_TX_tb/Busy_TX_TB
add wave -noupdate -expand -group TOP -color Magenta /UART_TX_tb/TX_OUT_TX_TB
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/CLK
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/RST
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/DATA_VALID
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/PAR_EN
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/ser_done
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/ser_en
add wave -noupdate -group FSM -color Cyan /UART_TX_tb/DUT/FSM_DUT/mux_sel
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/Busy
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/current_state
add wave -noupdate -group FSM /UART_TX_tb/DUT/FSM_DUT/next_state
add wave -noupdate -group Parity /UART_TX_tb/DUT/parity_calc_DUT/DATA_VALID
add wave -noupdate -group Parity /UART_TX_tb/DUT/parity_calc_DUT/PAR_TYP
add wave -noupdate -group Parity /UART_TX_tb/DUT/parity_calc_DUT/P_DATA
add wave -noupdate -group Parity -color {Medium Blue} /UART_TX_tb/DUT/parity_calc_DUT/par_bit
add wave -noupdate -group SER /UART_TX_tb/DUT/serializer_DUT/CLK
add wave -noupdate -group SER /UART_TX_tb/DUT/serializer_DUT/RST
add wave -noupdate -group SER /UART_TX_tb/DUT/serializer_DUT/P_DATA
add wave -noupdate -group SER /UART_TX_tb/DUT/serializer_DUT/ser_en
add wave -noupdate -group SER /UART_TX_tb/DUT/serializer_DUT/ser_done
add wave -noupdate -group SER -color Cyan /UART_TX_tb/DUT/serializer_DUT/ser_data
add wave -noupdate -group SER -color Magenta /UART_TX_tb/DUT/serializer_DUT/shift_reg
add wave -noupdate -group SER /UART_TX_tb/DUT/serializer_DUT/counter
add wave -noupdate -group MUX /UART_TX_tb/DUT/MUX_DUT/ser_data
add wave -noupdate -group MUX /UART_TX_tb/DUT/MUX_DUT/par_bit
add wave -noupdate -group MUX /UART_TX_tb/DUT/MUX_DUT/start_bit
add wave -noupdate -group MUX /UART_TX_tb/DUT/MUX_DUT/stop_bit
add wave -noupdate -group MUX /UART_TX_tb/DUT/MUX_DUT/mux_sel
add wave -noupdate -group MUX /UART_TX_tb/DUT/MUX_DUT/TX_OUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {34000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {361200 ps}
