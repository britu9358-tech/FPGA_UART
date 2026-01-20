`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 00:47:41
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps

module uart_tb;
    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire [7:0] rx_data;
    wire rx_valid;

    // Instantiate DUT (Device Under Test)
    uart_top dut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

    // 50 MHz clock → 20 ns period
    always #10 clk = ~clk;

    initial begin
        // Initial values
        clk = 0;
        rst = 1;
        tx_start = 0;
        tx_data = 8'h00;

        // Hold reset
        #100;
        rst = 0;

        // Wait a bit
        #100;

        // Send data
        tx_data = 8'h55;   // 01010101 (good test pattern)
        tx_start = 1;
#200_000;   // 200 us (greater than 1 baud period)
tx_start = 0;

        // Wait for RX to complete
        wait (rx_valid == 1);

        // Check result
        if (rx_data == 8'h55)
            $display("TEST PASSED: Received = %h", rx_data);
        else
            $display("TEST FAILED: Received = %h", rx_data);

        #100;
        $stop;
    end

endmodule

