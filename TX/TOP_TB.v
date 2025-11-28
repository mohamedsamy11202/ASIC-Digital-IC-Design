`timescale 1ns/1ps

module UART_TX_tb;

    // Parameters
    parameter CLK_PERIOD = 5; // 200 MHz --> 5 ns period

    // Inputs
    reg CLK_TX_TB;
    reg RST_TX_TB;
    reg PAR_TYP_TX_TB;
    reg PAR_EN_TX_TB;
    reg DATA_VALID_TX_TB;
    reg [7:0] P_DATA_TX_TB;

    // Outputs
    wire Busy_TX_TB;
    wire TX_OUT_TX_TB;

    // Instantiate DUT
    UART_TX DUT (
        .CLK_TX(CLK_TX_TB),
        .RST_TX(RST_TX_TB),
        .PAR_TYP_TX(PAR_TYP_TX_TB),
        .PAR_EN_TX(PAR_EN_TX_TB),
        .DATA_VALID_TX(DATA_VALID_TX_TB),
        .P_DATA_TX(P_DATA_TX_TB),
        .Busy_TX(Busy_TX_TB),
        .TX_OUT_TX(TX_OUT_TX_TB)
    );

    // Clock Generation (200 MHz)
    always #(CLK_PERIOD/2) CLK_TX_TB = ~CLK_TX_TB;

    // Task to capture the transmitted frame
    task display_frame;
        integer i;
        reg [15:0] frame_bits; // Enough space for start+data+parity+stop
        integer bit_count;
    begin
        bit_count = 0;
        
        // Wait until TX starts
        wait (Busy_TX_TB == 1);
        $display("%t: Transmission started", $time);

        // Capture bits until TX finishes (sampling method depends on your baud)
        while (Busy_TX_TB == 1) begin
            @(posedge CLK_TX_TB);
            frame_bits[bit_count] = TX_OUT_TX_TB;
            bit_count = bit_count + 1;
        end
        
        // Display the captured frame
        $write("%t: Captured UART Frame (%0d bits): ", $time, bit_count);
        for (i = 0; i < bit_count; i = i + 1) begin
            $write("%b ", frame_bits[i]);
        end
        $display("\n%t: Frame Sent ✅", $time);
    end
    endtask

    // Task to apply stimulus
    task apply_test(
        input [7:0] data,
        input parity_enable,
        input parity_type
    );
    begin
        @(negedge CLK_TX_TB);
        P_DATA_TX_TB = data;
        PAR_EN_TX_TB = parity_enable;
        PAR_TYP_TX_TB = parity_type;
        DATA_VALID_TX_TB = 1'b1;
        @(negedge CLK_TX_TB);
        DATA_VALID_TX_TB = 1'b0;

        // Capture and display the frame
        display_frame();
        
        $display("%t: Data = 0x%0h | Parity Enable = %b | Parity Type = %b\n",
                 $time, data, parity_enable, parity_type);
    end
    endtask

    // Test Sequence
    initial begin
        // Force printed time to be in integer nanoseconds (no decimals)
        // $timeformat(unit, precision, suffix, field_width)
        // unit = -9 => ns, precision = 0 => integer, suffix = " ns"
        $timeformat(-9, 0, " ns", 12);

        // Initial Values
        CLK_TX_TB = 0;
        RST_TX_TB = 1;
        DATA_VALID_TX_TB = 0;
        P_DATA_TX_TB = 8'b0;
        PAR_EN_TX_TB = 0;
        PAR_TYP_TX_TB = 0;

        // Reset pulse
        #10;
        RST_TX_TB = 0;
        #10;
        RST_TX_TB = 1;

        // Test Cases
        $display("========== UART_TX Test Start (%t) ==========", $time);
        apply_test(8'hA5, 1'b0, 1'b0);  // No parity
        apply_test(8'h3C, 1'b1, 1'b0);  // Even parity
        apply_test(8'h3C, 1'b1, 1'b1);  // Odd parity
        apply_test(8'hFF, 1'b1, 1'b0);  // All ones, even parity
        apply_test(8'h00, 1'b1, 1'b1);  // All zeros, odd parity

        $display("========== UART_TX Test End (%t) ==========", $time);
        #50 $stop;
    end

endmodule
