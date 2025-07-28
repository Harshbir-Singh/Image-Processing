# Image-Processing
This repository contains a Verilog-based image processing project designed using Xilinx Vivado Design Suite, targeting the AMD Zynq UltraScale+ MPSoC ZCU104 development board. The system processes a 512x512 grayscale image by applying a 3x3 convolution kernel, selectable through testbench-driven modes.

Project Features:
- Image Size: 512x512 pixels (grayscale,.bmp, 8-bit depth).

- Kernel Size: 3x3 convolution filter.

- Convolution Modes:

  00: Mode 0 (Edge Detection)

  01: Mode 1 (Box Blur)

  10: Mode 2 (Emboss 3D effect)

  11: Mode 3 (Unsharp Mask)

- Fully simulated with a testbench demonstrating functional correctness of all modes.

- Modular Verilog design, scalable for larger image sizes or kernel operations.

Verilog Modules:

- lineBuffer.v
Implements line buffer behavior with 512-length registers, supporting pixel-wise read/write operations for 8-bit grayscale values.

- conv.v
Performs the core 3x3 convolution operation, receiving pixel data from the line buffers and applying the selected kernel based on mode selection.

- imageControl.v
Manages three line buffers to handle vertical data shifting, ensuring that the convolution module always has access to a valid 3x3 window of pixels.

- outputBuffer (FIFO Generator IP Core)
Acts as an output FIFO, buffering processed pixel data until the DMA controller is ready to fetch the next data chunk.

- imageProcessTop.v
Top-level integration module that connects all submodules, handles synchronization, and interfaces with external components for data input/output.

Test Images:

<img width="548" height="272" alt="image" src="https://github.com/user-attachments/assets/87028c52-5528-400e-944a-af4bd1f7d313" />

Processed Images:

<img width="1720" height="561" alt="image" src="https://github.com/user-attachments/assets/8d3c3d01-2395-4adf-8047-b05f81a74147" />

