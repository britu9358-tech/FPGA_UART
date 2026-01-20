`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 00:43:00
// Design Name: 
// Module Name: uart_rx
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


module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx_tick,     // 16x baud tick
    input  wire       rx,           // serial input
    output reg [7:0]  rx_data,      // received byte
    output reg        rx_valid      // 1-cycle pulse
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [3:0] sample_cnt;   // counts 0-15
    reg [2:0] bit_index;    // counts 0-7
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            state      <= IDLE;
            sample_cnt <= 0;
            bit_index  <= 0;
            shift_reg  <= 0;
            rx_data    <= 0;
            rx_valid   <= 1'b0;
        end else begin
            rx_valid <= 1'b0; // default

            if (rx_tick) begin
                case (state)

                    IDLE: begin
                        if (rx == 1'b0) begin
                            state <= START;
                            sample_cnt <= 0;
                        end
                    end

                    START: begin
                        if (sample_cnt == 4'd7) begin
                            // middle of start bit
                            if (rx == 1'b0) begin
                                state <= DATA;
                                sample_cnt <= 0;
                                bit_index <= 0;
                            end else begin
                                state <= IDLE; // false start
                            end
                        end else begin
                            sample_cnt <= sample_cnt + 1;
                        end
                    end

                    DATA: begin
                        if (sample_cnt == 4'd15) begin
                            sample_cnt <= 0;
                            shift_reg <= {rx, shift_reg[7:1]}; // LSB first

                            if (bit_index == 3'd7)
                                state <= STOP;
                            else
                                bit_index <= bit_index + 1;
                        end else begin
                            sample_cnt <= sample_cnt + 1;
                        end
                    end

                    STOP: begin
                        if (sample_cnt == 4'd15) begin
                            state <= IDLE;
                            rx_data <= shift_reg;
                            rx_valid <= 1'b1;   // DATA READY
                        end else begin
                            sample_cnt <= sample_cnt + 1;
                        end
                    end

                endcase
            end
        end
    end
endmodule

