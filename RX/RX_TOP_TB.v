`timescale 1ns/1ps

module UART_RX_tb;

  // Clock control
  real TX_CLK_FREQ   = 115200.0;       // Hz
  real RX_CLK_FREQ;
  real RX_CLK_PERIOD;

  // DUT inputs
  reg        CLK_RX_tb;
  reg        RST_RX_tb;
  reg        RX_IN_tb;
  reg [5:0]  prescale_tb;
  reg        PAR_EN_tb;
  reg        PAR_TYP_tb;

  // DUT outputs
  wire [7:0] P_DATA_tb;
  wire       Parity_error_tb;
  wire       Stop_Error_tb;
  wire       data_valid_tb;

  // DUT Instantiation
  UART_RX DUT (
    .CLK_RX(CLK_RX_tb),
    .RST_RX(RST_RX_tb),
    .RX_IN(RX_IN_tb),
    .Prescale(prescale_tb),
    .PAR_EN(PAR_EN_tb),
    .PAR_TYP(PAR_TYP_tb),
    .P_DATA(P_DATA_tb),
    .Parity_error(Parity_error_tb),
    .Stop_Error(Stop_Error_tb),
    .data_valid(data_valid_tb)
  );

  // Clock generation
  always #(RX_CLK_PERIOD/2) CLK_RX_tb = ~CLK_RX_tb;

  // Task to transmit UART frame
  task UART_WRITE_BYTE(input [7:0] data, input integer prescale);
    integer i;
    reg parity_bit;
    begin
      // Start bit
      RX_IN_tb = 1'b0;
      #(prescale*RX_CLK_PERIOD);

      // Data bits (LSB first)
      for (i=0; i<8; i=i+1) begin
        RX_IN_tb = data[i];
        #(prescale*RX_CLK_PERIOD);
      end

      // Parity
      if (PAR_EN_tb) begin
        if (PAR_TYP_tb)  // Odd parity
          parity_bit = ~(^data);
        else             // Even parity
          parity_bit =  ^data;
        RX_IN_tb = parity_bit;
        #(prescale*RX_CLK_PERIOD);
      end

      // Stop bit
      RX_IN_tb = 1'b1;
      #(prescale*RX_CLK_PERIOD);
    end
  endtask

  // Stimulus
  initial begin
    // Init
    RX_IN_tb   = 1'b1;  // idle
    PAR_EN_tb  = 1'b0;
    PAR_TYP_tb = 1'b0;
    RST_RX_tb  = 0;
    CLK_RX_tb  = 0;

    // Apply reset
    #(2*RX_CLK_PERIOD);
    RST_RX_tb = 1'b1;

    // ===================================================
    // CASE 1: Prescale = 8, no parity
    prescale_tb = 8;
    RX_CLK_FREQ   = TX_CLK_FREQ * prescale_tb;
    RX_CLK_PERIOD = 1e9 / RX_CLK_FREQ; // ns
    $display("\n---- TEST CASE 1: Prescale=%0d, Data=0xA5, No parity ----", prescale_tb);
    UART_WRITE_BYTE(8'hA5, prescale_tb);
    #(20*RX_CLK_PERIOD);
    if (P_DATA_tb == 8'ha5 && !Parity_error_tb && !Stop_Error_tb)
      $display("PASS: Received 0x%0H", P_DATA_tb);
    else
      $display("FAIL: Expected 0xA5, got 0x%0H", P_DATA_tb , $time);

    // ===================================================
    // CASE 2: Prescale = 16, even parity
    prescale_tb = 16;
    RX_CLK_FREQ   = TX_CLK_FREQ * prescale_tb;
    RX_CLK_PERIOD = 1e9 / RX_CLK_FREQ; // ns
    PAR_EN_tb   = 1'b1;
    PAR_TYP_tb  = 1'b0; // Even
    $display("\n---- TEST CASE 2: Prescale=%0d, Data=0x3C, Even parity ----", prescale_tb);
    UART_WRITE_BYTE(8'h3C, prescale_tb);
    #(25*RX_CLK_PERIOD);
    if (P_DATA_tb == 8'h3C && !Parity_error_tb && !Stop_Error_tb)
      $display("PASS: Correct data with even parity");
    else
      $display("FAIL: Data/parity mismatch, got 0x%0H", P_DATA_tb);

    // ===================================================
    // CASE 3: Prescale = 32, Odd parity
    prescale_tb = 32;
    RX_CLK_FREQ   = TX_CLK_FREQ * prescale_tb;
    RX_CLK_PERIOD = 1e9 / RX_CLK_FREQ; // ns
    PAR_EN_tb   = 1'b1;
    PAR_TYP_tb  = 1'b1; // Odd
    $display("\n---- TEST CASE 3: Prescale=%0d, Data=0x2E, Odd parity ----", prescale_tb);
    UART_WRITE_BYTE(8'h2E, prescale_tb);
    #(25*RX_CLK_PERIOD);
    if (P_DATA_tb == 8'h2E && !Parity_error_tb && !Stop_Error_tb)
      $display("PASS: Correct data with odd parity");
    else
      $display("FAIL: Data/parity mismatch, got 0x%0H", P_DATA_tb);

    // ===================================================
    // CASE 4: Back-to-back frames after stop bit
    prescale_tb = 16;
    RX_CLK_FREQ   = TX_CLK_FREQ * prescale_tb;
    RX_CLK_PERIOD = 1e9 / RX_CLK_FREQ; // ns
    PAR_EN_tb   = 1'b0; // no parity for this test
    PAR_TYP_tb  = 1'b0;
    $display("\n---- TEST CASE 4: Back-to-back frames (0x55 then 0xAA) ----");

    // Send first frame (0x55)
    UART_WRITE_BYTE(8'h55, prescale_tb);

    // Immediately send second frame (0xAA) after stop bit
    UART_WRITE_BYTE(8'hAA, prescale_tb);

    #(40*RX_CLK_PERIOD);

    if (P_DATA_tb == 8'hAA && !Parity_error_tb && !Stop_Error_tb)
      $display("PASS: Successfully received back-to-back frames, last=0x%0H", P_DATA_tb);
    else
      $display("FAIL: Back-to-back frame error, got 0x%0H", P_DATA_tb);

    $stop;
  end

endmodule
