# Image-Processing
This repository contains a Verilog-based image processing project designed using Xilinx Vivado Design Suite, targeting the AMD Zynq UltraScale+ MPSoC ZCU104 development board. The system processes a 512x512 grayscale image by applying a 3x3 convolution kernel, selectable through testbench-driven modes.

Project Features:
Image Size: 512x512 pixels (grayscale, 8-bit depth).

Kernel Size: 3x3 convolution filter.

Convolution Modes:

00: Mode 0 (e.g., Edge Detection)

01: Mode 1 (e.g., Blur)

10: Mode 2 (e.g., Sharpen)

11: Mode 3 (e.g., Custom Filter)

Fully simulated with a testbench demonstrating functional correctness of all modes.

Modular Verilog design, scalable for larger image sizes or kernel operations.

Verilog Modules:
lineBuffer.v
Implements line buffer behavior with 512-length registers, supporting pixel-wise read/write operations for 8-bit grayscale values.

conv.v
Performs the core 3x3 convolution operation, receiving pixel data from the line buffers and applying the selected kernel based on mode selection.

imageControl.v
Manages three line buffers to handle vertical data shifting, ensuring that the convolution module always has access to a valid 3x3 window of pixels.

outputBuffer (FIFO Generator IP Core)
Acts as an output FIFO, buffering processed pixel data until the DMA controller is ready to fetch the next data chunk.

imageProcessTop.v
Top-level integration module that connects all submodules, handles synchronization, and interfaces with external components for data input/output.

Key Highlights:
Designed for hardware-software co-design on FPGA.

Demonstrates efficient memory handling (line buffering) and pipelined convolution.

Flexible design with mode switching capability for dynamic kernel selection during simulation.

Testbench verifies all functional modes with waveform analysis.
