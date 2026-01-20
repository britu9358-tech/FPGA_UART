`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 00:44:56
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] tx_data,
    output wire       tx,
    output wire [7:0] rx_data,
    output wire       rx_valid
);

    // Internal wires
    wire tx_tick;
    wire rx_tick;
    wire tx_busy;
    wire rx_wire;

    // Loopback connection
    assign rx_wire = tx;

    // Baud rate generator
    baud_gen #(
        .CLK_FREQ(50_000_000),
        .BAUD(9600)
    ) baud_inst (
        .clk(clk),
        .rst(rst),
        .tx_tick(tx_tick),
        .rx_tick(rx_tick)
    );

    // UART Transmitter
    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_tick(tx_tick),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // UART Receiver
    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx_tick(rx_tick),
        .rx(rx_wire),
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );

endmodule

