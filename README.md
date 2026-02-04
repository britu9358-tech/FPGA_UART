# FPGA-Based UART Communication System

## Overview
This project implements a complete **UART (Universal Asynchronous Receiver Transmitter)** communication system using **Verilog HDL**.  
The design includes a baud-rate generator, UART transmitter, UART receiver, and a top-level integration module, and is verified using **RTL simulation in Vivado**.

The objective of this project is to understand **asynchronous serial communication**, **FSM-based RTL design**, and **baud-rate timing** in an FPGA-oriented environment.

---

## Features
- UART Transmitter and Receiver (8N1 format)
- FSM-based control logic
- Configurable baud-rate generation
- 16× oversampling-based receiver
- Internal loopback for full functional verification
- RTL simulation and waveform-based debugging

---

## UART Frame Format
The design follows the standard **8N1 UART protocol**:
- 1 Start bit (logic 0)
- 8 Data bits (LSB first)
- No parity
- 1 Stop bit (logic 1)

Total frame length: **10 bits per transmission**

---

## Architecture Overview
The system consists of the following modules:

1. **Baud Rate Generator**
   - Generates timing pulses for UART transmission and reception
   - TX tick at baud rate
   - RX tick at 16× baud rate for oversampling

2. **UART Transmitter (TX)**
   - FSM-based design (IDLE, START, DATA, STOP)
   - Converts parallel 8-bit data into serial UART format
   - Operates synchronously with TX baud tick

3. **UART Receiver (RX)**
   - FSM-based receiver with oversampling
   - Uses mid-bit sampling for reliable data recovery
   - Reconstructs serial data into 8-bit parallel format
   - Generates a one-clock `rx_valid` pulse on successful reception

4. **Top Module**
   - Integrates baud generator, transmitter, and receiver
   - Implements internal loopback (TX → RX) for simulation verification

---

## Module Description

### 1. Baud Rate Generator (`baud_gen.v`)
- Converts high-frequency system clock (50 MHz) into UART timing signals
- Generates:
  - `tx_tick` → one pulse per UART bit
  - `rx_tick` → 16 pulses per UART bit for oversampling

### 2. UART Transmitter (`uart_tx.v`)
- FSM-based serial transmitter
- Sends start bit, data bits (LSB first), and stop bit
- Uses shift register and bit counter
- Transmission advances only on `tx_tick`

### 3. UART Receiver (`uart_rx.v`)
- FSM-based serial receiver
- Detects start bit and confirms it using mid-bit sampling
- Samples data bits using 16× oversampling
- Outputs received byte and asserts `rx_valid`

### 4. Top Module (`uart_top.v`)
- Instantiates all UART submodules
- Distributes baud timing
- Enables end-to-end UART verification using loopback

---

## Verification & Simulation
- Verified using **RTL simulation in Vivado**
- Testbench applies known data patterns (e.g., `0x55`)
- TX output is looped back to RX input
- Correct reception is verified through waveform analysis and `rx_valid` signaling
- Simulation runtime extended to milliseconds to observe UART behavior

---

## Testbench (`uart_tb.v`)
- Generates 50 MHz system clock
- Applies reset and initiates UART transmission
- Sends known data (`0x55`)
- Allows observation of TX/RX behavior and timing

---

## Tools & Technologies
- Verilog HDL
- Xilinx Vivado
- RTL Simulation & Debugging
- FSM-based Digital Design

---

## Project Status
- RTL Design: Complete  
- Simulation: Verified  
- FPGA Deployment: FPGA-ready (board integration supported)

---

## Possible Enhancements
- Add parity and framing error detection
- Implement RX/TX FIFOs for buffering
- Support programmable baud rates
- Add interrupt-based signaling
- Extend design for FPGA board testing via USB-UART

---

## Learning Outcomes
- Understanding of asynchronous serial communication
- FSM-based RTL design methodology
- Baud-rate generation and oversampling techniques
- Practical RTL simulation and debugging experience
- Modular FPGA-oriented design practices

---

## Author
Developed as part of an academic FPGA/RTL design project to gain hands-on experience in UART protocol implementation and verification.
