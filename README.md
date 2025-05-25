# BYU_Pynq_PR_Video_Pipeline_Hardware
BYU Pynq PR Video Pipeline Hardware.

## Setup and Build Instructions

1.  **Build IP Cores:** Firstly build the IP cores using `source build_base_ip.tcl`. **Vivado HLS Note:** after 2022 Vivado HLS (required for building IPs) will not work without a fix described in this article: [Number Overflow Issue Y2K22](https://adaptivesupport.amd.com/s/article/76960?language=en_US).
2.  **Build Vivado Project:** To build the project, run `source video.tcl`.

**[Block Design Diagram](doc/video_bd.pdf):**
<img alt="Tracing Program Example for ADD Instruction" src="doc\video_bd.png">
