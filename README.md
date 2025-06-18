# BYU_Pynq_PR_Video_Pipeline_Hardware
BYU Pynq PR Video Pipeline Hardware.

## Setup and Build Instructions

<a id="Step2"></a>

1. **Build IP Cores:** Firstly navigate to `/Pynq-Z1/video` directory and build the IP cores using `source build_base_ip.tcl`. **Vivado HLS Note:** after 2022 Vivado HLS (required for building IPs) will not work without a fix described in this article: [Number Overflow Issue Y2K22](https://adaptivesupport.amd.com/s/article/76960?language=en_US).


<a id="Step2"></a>

2. **Generate and Synthesize Vivado Project:** Run `source video.tcl`. This step will:

    1. Generate Vivado project [Block Design Diagram](doc/system.bd.pdf):<img src="doc\system.bd.png">

    2. This Block Design has a [Video](doc/system.bd.video.pdf) submodule with black-box placeholders (undefined contents) for Partial Ceconfiguration (PR) modules, i.e. HLS_PR_WRAPPER_[0-9] and HLS_Merger_0:<img src="doc\system.bd.video.png">


    3. `bare_top.v` is set as top module with `constrains/top.xdc` constrains file.

    4. This step only synthesizes vivado project, but DOES NOT perfrom implementatin/bitstream generation (which are done later in [Step 3.7](#Step3.7)).

    5. Finally it writes a checkpoint: `write_checkpoint -force ../../drp/Static/top.dcp`


<a id="Step3"></a>

3. **Build a static Vivado Design:** Navigate to `/drp` directory and build a static design running `source build_static_design.tcl`. This step performs the following:


    1. Run **Vivado implementation**. Generated checkpoint is stored using `write_checkpoint -force Implement/pass_route_design.dcp`)

    2. Generates **Vivavdo Bitstream**, which is stored  using `write_bitstream -file Bitstreams/video.bit -force`

    <a id="Step3.3"></a>

    3. **Generates partially synthesized designs** for HLS_PR_WRAPPER_[0-9] and HLS_Merger_0 (storing *.dcp filfes into `/drp/Synth` folder).

    4. **Generate combined (static + PR) design**. Firstly we read the `/Static/top.dcp` checkpoint from [Step 2](#Step2) and partially synthesized designs from [Step 3.3](#Step3.3). PR designs are marked as reconfigurable (`set_property HD.RECONFIGURABLE 1`). A combined design (which now includes the static design and the marked reconfigurable regions) is saved into a checkpoint using `write_checkpoint -force ./Checkpoint/pr_block_design.dcp` command.

    5. **Define Pblocks (Physical Partitions) for Reconfigurable Modules**. Define rectangular region on the FPGA fabric where a reconfigurable module can be placed with `create_pblock <name>`. Set specific SLICE XY coordinates to plase each PBlock.

    6. Read constarints (`Const/top.xdc` and `Const/1080p.xdc`).

    <a id="Step3.7"></a>

    7. Perform Vivado Design Implementation (PLace&Route), store implementation checkpint (`write_checkpoint -force Implement/pass_route_design.dcp`). Genereate output bitstream file (`write_bitstream -file Bitstreams/video.bit -force`) and store the overall static design checkpoint (`write_checkpoint -force Checkpoint/static_route_design.dcp`)


