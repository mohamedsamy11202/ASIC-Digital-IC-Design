`timescale 1ns/1ps

module SYS_TOP_TB;

  /////////////////////////////////////////////////////////
  ///////////////////// Parameters ////////////////////////
  /////////////////////////////////////////////////////////
  parameter DATA_WIDTH = 8;
  parameter RF_ADDR    = 4;

  // Clocks
  parameter REF_CLK_PER  = 20;       // 50 MHz
  parameter UART_CLK_PER = 271.267;  // 3.6864 MHz (115.2 * 32 oversample)

  // UART timing
  parameter BAUD_RATE      = 115200;
  parameter UART_BIT_PERIOD = 1_000_000_000 / BAUD_RATE;  // ns/bit ≈ 8680 ns

  /////////////////////////////////////////////////////////
  ////////////////////// DUT Signals //////////////////////
  /////////////////////////////////////////////////////////
  reg  RST_N;
  reg  UART_CLK;
  reg  REF_CLK;
  reg  UART_RX_IN;

  wire UART_TX_O;
  wire parity_error;
  wire framing_error;

  /////////////////////////////////////////////////////////
  ////////////////////// DUT Instance /////////////////////
  /////////////////////////////////////////////////////////
  SYS_TOP #(
    .DATA_WIDTH(DATA_WIDTH),
    .RF_ADDR   (RF_ADDR)
  ) DUT (
    .RST_N(RST_N),
    .UART_CLK(UART_CLK),
    .REF_CLK(REF_CLK),
    .UART_RX_IN(UART_RX_IN),
    .UART_TX_O(UART_TX_O),
    .parity_error(parity_error),
    .framing_error(framing_error)
  );

  /////////////////////////////////////////////////////////
  ////////////////////// Clock Gen ////////////////////////
  /////////////////////////////////////////////////////////
  initial begin
    REF_CLK = 0;
    forever #(REF_CLK_PER/2.0) REF_CLK = ~REF_CLK;
  end

  initial begin
    UART_CLK = 0;
    forever #(UART_CLK_PER/2.0) UART_CLK = ~UART_CLK;
  end

  /////////////////////////////////////////////////////////
  ////////////////////// Reset Seq ////////////////////////
  /////////////////////////////////////////////////////////
  initial begin
    RST_N = 0;
    UART_RX_IN = 1;  // idle
    #(10*REF_CLK_PER);
    RST_N = 1;
  end

  /////////////////////////////////////////////////////////
  ////////////////// UART Send Task ///////////////////////
  /////////////////////////////////////////////////////////
  task send_uart_frame;
    input [7:0] data;
    integer i;
    reg parity_bit;
    begin
      // Start bit
      UART_RX_IN = 0;
      #UART_BIT_PERIOD;

      // Data bits (LSB first)
      for (i=0; i<8; i=i+1) begin
        UART_RX_IN = data[i];
        #UART_BIT_PERIOD;
      end

      // Parity bit (even)
      parity_bit = ^data;
      UART_RX_IN = parity_bit;
      #UART_BIT_PERIOD;

      // Stop bit
      UART_RX_IN = 1;
      #UART_BIT_PERIOD;
    end
  endtask

  /////////////////////////////////////////////////////////
  ////////////////////// Stimulus /////////////////////////
  /////////////////////////////////////////////////////////
  initial begin
    @(posedge RST_N);
    #(5*UART_BIT_PERIOD);

    // ===============================
    // 1) Configure UART & Clock Divider
    // ===============================
    $display("[%0t] Configure UART & Divider", $time);

    // Write to REG2 (UART_Config)
    send_uart_frame(8'hAA);  // RF_Wr_CMD
    send_uart_frame(8'h02);  // Address
    send_uart_frame(8'b10000001); // Example config

    // Write to REG3 (DIV_RATIO)
    send_uart_frame(8'hAA);  // RF_Wr_CMD
    send_uart_frame(8'h03);  // Address
    send_uart_frame(8'd32);  // Division ratio

    // ===============================
    // 2) Test Register File Write
    // ===============================
    $display("[%0t] RF Write test", $time);
    send_uart_frame(8'hAA);  // RF_Wr_CMD
    send_uart_frame(8'h04);  // Address
    send_uart_frame(8'd15);  // Data

    // ===============================
    // 3) Test Register File Read
    // ===============================
    $display("[%0t] RF Read test", $time);
    send_uart_frame(8'hBB);  // RF_Rd_CMD
    send_uart_frame(8'h04);  // Address
    // Expect DUT to TX back 15

    // ===============================
    // 4) ALU Operation with operands
    // ===============================
    $display("[%0t] ALU ADD test", $time);
    send_uart_frame(8'hCC);  // ALU_CMD with operands
    send_uart_frame(8'd10);  // Operand A
    send_uart_frame(8'd5);   // Operand B
    send_uart_frame(8'b0000); // ALU_FUN = ADD
    // Expect DUT result = 15

    // ===============================
    // 5) ALU Operation without operands
    // ===============================
    $display("[%0t] ALU Shift test", $time);
    send_uart_frame(8'hDD);  // ALU_CMD without operands
    send_uart_frame(8'b1011); // ALU_FUN = SHIFT_LEFT
    // Expect DUT result = A << 1

    #100_000;
    $display("[%0t] Simulation finished.", $time);
    $stop;
  end

  /////////////////////////////////////////////////////////
  ////////////////////// VCD Dump /////////////////////////
  /////////////////////////////////////////////////////////
  initial begin
    $dumpfile("sys_top_tb.vcd");
    $dumpvars(0, SYS_TOP_TB);
  end

endmodule
