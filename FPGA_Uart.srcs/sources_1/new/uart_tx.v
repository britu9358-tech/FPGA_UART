`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 00:36:36
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_tick,      // from baud_gen
    input  wire       tx_start,     // start transmission
    input  wire [7:0] tx_data,      // parallel data
    output reg        tx,            // serial output
    output reg        tx_busy
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            tx        <= 1'b1;   // idle line high
            tx_busy  <= 1'b0;
            bit_index <= 3'd0;
            shift_reg <= 8'd0;
        end else if (tx_tick) begin
            case (state)

                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        shift_reg <= tx_data;
                        state <= START;
                        tx_busy <= 1'b1;
                    end
                end

                START: begin
                    tx <= 1'b0;  // start bit
                    state <= DATA;
                    bit_index <= 3'd0;
                end

                DATA: begin
                    tx <= shift_reg[0];          // LSB first
                    shift_reg <= shift_reg >> 1;
                    if (bit_index == 3'd7)
                        state <= STOP;
                    else
                        bit_index <= bit_index + 1;
                end

                STOP: begin
                    tx <= 1'b1;  // stop bit
                    state <= IDLE;
                end

            endcase
        end
    end
endmodule

