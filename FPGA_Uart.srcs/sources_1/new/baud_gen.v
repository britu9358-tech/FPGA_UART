`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 00:24:40
// Design Name: 
// Module Name: baud_gen
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


module baud_gen #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD     = 9600
)(
    input  wire clk,
    input  wire rst,
    output reg  tx_tick,
    output reg  rx_tick
);

    localparam integer TX_DIV = CLK_FREQ / BAUD;          // ≈ 5208
    localparam integer RX_DIV = CLK_FREQ / (BAUD * 16);   // ≈ 325

    integer tx_cnt;
    integer rx_cnt;

    always @(posedge clk) begin
        if (rst) begin
            tx_cnt  <= 0;
            rx_cnt  <= 0;
            tx_tick <= 1'b0;
            rx_tick <= 1'b0;
        end else begin
            // TX baud tick
            if (tx_cnt == TX_DIV-1) begin
                tx_cnt  <= 0;
                tx_tick <= 1'b1;
            end else begin
                tx_cnt  <= tx_cnt + 1;
                tx_tick <= 1'b0;
            end

            // RX oversampling tick (16x)
            if (rx_cnt == RX_DIV-1) begin
                rx_cnt  <= 0;
                rx_tick <= 1'b1;
            end else begin
                rx_cnt  <= rx_cnt + 1;
                rx_tick <= 1'b0;
            end
        end
    end
endmodule

