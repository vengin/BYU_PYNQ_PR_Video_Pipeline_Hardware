
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project video video -part xc7z020clg400-1
}

set_property  ip_repo_paths  ../../ip [current_project]
update_ip_catalog

# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_protocol_converter:2.1\                                         
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:user:HLS_Merger:1.0\
xilinx.com:user:HLS_PR_WRAPPER:1.0\
xilinx.com:user:PR_Control:1.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:axis_broadcaster:1.1\
xilinx.com:ip:axis_data_fifo:1.1\
xilinx.com:ip:axis_switch:1.1\
xilinx.com:ip:axis_register_slice:1.1\
xilinx.com:hls:color_convert:1.0\
xilinx.com:hls:pixel_unpack:1.0\
xilinx.com:hls:pixel_pack:1.0\
xilinx:user:color_swap:1.0\
digilentinc.com:ip:dvi2rgb:1.7\
xilinx.com:ip:v_vid_in_axi4s:4.0\
xilinx.com:ip:v_tc:6.1\
digilentinc.com:ip:axi_dynclk:1.0\
digilentinc.com:ip:rgb2dvi:1.2\
xilinx.com:ip:v_axi4s_vid_out:4.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: frontend
proc create_hier_cell_frontend_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_frontend_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S02_AXILite
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S04_AXILite
  create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_out
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 video_in

  # Create pins
  create_bd_pin -dir I PixelClk
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -type clk clk_142M
  create_bd_pin -dir O -from 0 -to 0 hdmi_out_hpd
  create_bd_pin -dir O -type intr hdmi_out_hpd_irq
  create_bd_pin -dir I -from 0 -to 0 -type rst periph_resetn_clk100M
  create_bd_pin -dir O -type intr vtc_out_irq

  # Create instance: axi_dynclk, and set properties
  set axi_dynclk [ create_bd_cell -type ip -vlnv digilentinc.com:ip:axi_dynclk:1.0 axi_dynclk ]

  set_property -dict [ list \
   CONFIG.NUM_READ_OUTSTANDING {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {1} \
 ] [get_bd_intf_pins /video/hdmi_out/frontend/axi_dynclk/s00_axi]

  # Create instance: color_swap_0, and set properties
  set color_swap_0 [ create_bd_cell -type ip -vlnv xilinx:user:color_swap:1.0 color_swap_0 ]

  # Create instance: hdmi_out_hpd_video, and set properties
  set hdmi_out_hpd_video [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 hdmi_out_hpd_video ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $hdmi_out_hpd_video

  # Create instance: rgb2dvi_0, and set properties
  set rgb2dvi_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.2 rgb2dvi_0 ]
  set_property -dict [ list \
   CONFIG.kClkRange {2} \
   CONFIG.kGenerateSerialClk {true} \
   CONFIG.kRstActiveHigh {false} \
 ] $rgb2dvi_0

  # Create instance: v_axi4s_vid_out_0, and set properties
  set v_axi4s_vid_out_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {11} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_HYSTERESIS_LEVEL {1024} \
   CONFIG.C_VTG_MASTER_SLAVE {0} \
 ] $v_axi4s_vid_out_0

  # Create instance: vtc_out, and set properties
  set vtc_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 vtc_out ]
  set_property -dict [ list \
   CONFIG.enable_detection {false} \
 ] $vtc_out

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins TMDS_out] [get_bd_intf_pins rgb2dvi_0/TMDS]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S02_AXILite] [get_bd_intf_pins vtc_out/ctrl]
  connect_bd_intf_net -intf_net color_swap_0_pixel_output [get_bd_intf_pins color_swap_0/pixel_output] [get_bd_intf_pins rgb2dvi_0/RGB]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins hdmi_out_hpd_video/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins S04_AXILite] [get_bd_intf_pins axi_dynclk/s00_axi]
  connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins color_swap_0/pixel_input] [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out]
  connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins vtc_out/vtiming_out]
  connect_bd_intf_net -intf_net video_in_1 [get_bd_intf_pins video_in] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins clk_100M] [get_bd_pins axi_dynclk/REF_CLK_I] [get_bd_pins axi_dynclk/s00_axi_aclk] [get_bd_pins hdmi_out_hpd_video/s_axi_aclk] [get_bd_pins vtc_out/s_axi_aclk]
  connect_bd_net -net Net1 [get_bd_pins periph_resetn_clk100M] [get_bd_pins axi_dynclk/s00_axi_aresetn] [get_bd_pins hdmi_out_hpd_video/s_axi_aresetn] [get_bd_pins vtc_out/s_axi_aresetn]
  connect_bd_net -net PixelClk_1 [get_bd_pins PixelClk] [get_bd_pins color_swap_0/pixel_clk] [get_bd_pins rgb2dvi_0/PixelClk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins vtc_out/clk]
  connect_bd_net -net aclk_1 [get_bd_pins clk_142M] [get_bd_pins v_axi4s_vid_out_0/aclk]
  connect_bd_net -net axi_dynclk_LOCKED_O [get_bd_pins axi_dynclk/LOCKED_O] [get_bd_pins rgb2dvi_0/aRst_n]
  connect_bd_net -net hdmi_out_hpd_video_gpio_io_o [get_bd_pins hdmi_out_hpd] [get_bd_pins hdmi_out_hpd_video/gpio_io_o]
  connect_bd_net -net hdmi_out_hpd_video_ip2intc_irpt [get_bd_pins hdmi_out_hpd_irq] [get_bd_pins hdmi_out_hpd_video/ip2intc_irpt]
  connect_bd_net -net v_axi4s_vid_out_0_status [get_bd_pins hdmi_out_hpd_video/gpio2_io_i] [get_bd_pins v_axi4s_vid_out_0/status]
  connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins vtc_out/gen_clken]
  connect_bd_net -net v_tc_0_irq [get_bd_pins vtc_out_irq] [get_bd_pins vtc_out/irq]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: frontend
proc create_hier_cell_frontend { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_frontend() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 DDC
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S02_AXILite
  create_bd_intf_pin -mode Slave -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_in
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 video_out

  # Create pins
  create_bd_pin -dir O -type clk PixelClk
  create_bd_pin -dir O aPixelClkLckd
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -type clk clk_142M
  create_bd_pin -dir I -type clk clk_200M
  create_bd_pin -dir O -from 0 -to 0 hdmi_in_hpd
  create_bd_pin -dir O -type intr hdmi_in_hpd_irq
  create_bd_pin -dir I -from 0 -to 0 -type rst periph_resetn_clk100M
  create_bd_pin -dir I -from 0 -to 0 -type rst resetn
  create_bd_pin -dir I -from 0 -to 0 -type rst vid_io_in_reset
  create_bd_pin -dir O -type intr vtc_in_irq

  # Create instance: axi_gpio_hdmiin, and set properties
  set axi_gpio_hdmiin [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_hdmiin ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO2_WIDTH {1} \
   CONFIG.C_GPIO_WIDTH {1} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_hdmiin

  # Create instance: color_swap_0, and set properties
  set color_swap_0 [ create_bd_cell -type ip -vlnv xilinx:user:color_swap:1.0 color_swap_0 ]
  set_property -dict [ list \
   CONFIG.input_format {rbg} \
   CONFIG.output_format {rgb} \
 ] $color_swap_0

  # Create instance: dvi2rgb_0, and set properties
  set dvi2rgb_0 [ create_bd_cell -type ip -vlnv digilentinc.com:ip:dvi2rgb:1.7 dvi2rgb_0 ]
  set_property -dict [ list \
   CONFIG.kAddBUFG {true} \
   CONFIG.kClkRange {1} \
   CONFIG.kEdidFileName {1080_edid.data} \
   CONFIG.kRstActiveHigh {false} \
 ] $dvi2rgb_0

  # Create instance: v_vid_in_axi4s_0, and set properties
  set v_vid_in_axi4s_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 v_vid_in_axi4s_0 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {13} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
 ] $v_vid_in_axi4s_0

  # Create instance: vtc_in, and set properties
  set vtc_in [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.1 vtc_in ]
  set_property -dict [ list \
   CONFIG.HAS_INTC_IF {true} \
   CONFIG.enable_generation {false} \
   CONFIG.horizontal_blank_detection {false} \
   CONFIG.max_lines_per_frame {2048} \
   CONFIG.vertical_blank_detection {false} \
 ] $vtc_in

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins DDC] [get_bd_intf_pins dvi2rgb_0/DDC]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins TMDS_in] [get_bd_intf_pins dvi2rgb_0/TMDS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S02_AXILite] [get_bd_intf_pins vtc_in/ctrl]
  connect_bd_intf_net -intf_net color_swap_0_pixel_output [get_bd_intf_pins color_swap_0/pixel_output] [get_bd_intf_pins v_vid_in_axi4s_0/vid_io_in]
  connect_bd_intf_net -intf_net dvi2rgb_0_RGB [get_bd_intf_pins color_swap_0/pixel_input] [get_bd_intf_pins dvi2rgb_0/RGB]
  connect_bd_intf_net -intf_net hdmi_in_video_out [get_bd_intf_pins video_out] [get_bd_intf_pins v_vid_in_axi4s_0/video_out]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M07_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins axi_gpio_hdmiin/S_AXI]
  connect_bd_intf_net -intf_net v_vid_in_axi4s_0_vtiming_out [get_bd_intf_pins v_vid_in_axi4s_0/vtiming_out] [get_bd_intf_pins vtc_in/vtiming_in]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins clk_100M] [get_bd_pins axi_gpio_hdmiin/s_axi_aclk] [get_bd_pins vtc_in/s_axi_aclk]
  connect_bd_net -net Net1 [get_bd_pins periph_resetn_clk100M] [get_bd_pins axi_gpio_hdmiin/s_axi_aresetn] [get_bd_pins dvi2rgb_0/aRst_n] [get_bd_pins vtc_in/s_axi_aresetn]
  connect_bd_net -net RefClk_1 [get_bd_pins clk_200M] [get_bd_pins dvi2rgb_0/RefClk]
  connect_bd_net -net aclk_1 [get_bd_pins clk_142M] [get_bd_pins v_vid_in_axi4s_0/aclk]
  connect_bd_net -net axi_gpio_video_gpio_io_o [get_bd_pins hdmi_in_hpd] [get_bd_pins axi_gpio_hdmiin/gpio_io_o]
  connect_bd_net -net axi_gpio_video_ip2intc_irpt [get_bd_pins hdmi_in_hpd_irq] [get_bd_pins axi_gpio_hdmiin/ip2intc_irpt]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins PixelClk] [get_bd_pins color_swap_0/pixel_clk] [get_bd_pins dvi2rgb_0/PixelClk] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_clk] [get_bd_pins vtc_in/clk]
  connect_bd_net -net dvi2rgb_0_aPixelClkLckd [get_bd_pins aPixelClkLckd] [get_bd_pins axi_gpio_hdmiin/gpio2_io_i] [get_bd_pins dvi2rgb_0/aPixelClkLckd]
  connect_bd_net -net resetn_1 [get_bd_pins resetn] [get_bd_pins vtc_in/resetn]
  connect_bd_net -net v_tc_1_irq [get_bd_pins vtc_in_irq] [get_bd_pins vtc_in/irq]
  connect_bd_net -net vid_io_in_reset_1 [get_bd_pins vid_io_in_reset] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_reset]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_out
proc create_hier_cell_hdmi_out { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hdmi_out() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S02_AXILite
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S04_AXILite
  create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_out
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 video_in

  # Create pins
  create_bd_pin -dir I PixelClk
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -type clk clk_142M
  create_bd_pin -dir O -from 0 -to 0 hdmi_out_hpd
  create_bd_pin -dir O -type intr hdmi_out_hpd_irq
  create_bd_pin -dir I -from 0 -to 0 -type rst periph_resetn_clk100M
  create_bd_pin -dir O -type intr vtc_out_irq

  # Create instance: frontend
  create_hier_cell_frontend_1 $hier_obj frontend

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins TMDS_out] [get_bd_intf_pins frontend/TMDS_out]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S02_AXILite] [get_bd_intf_pins frontend/S02_AXILite]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M06_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins frontend/S00_AXILite]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M08_AXI [get_bd_intf_pins S04_AXILite] [get_bd_intf_pins frontend/S04_AXILite]
  connect_bd_intf_net -intf_net video_in_1 [get_bd_intf_pins video_in] [get_bd_intf_pins frontend/video_in]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins clk_100M] [get_bd_pins frontend/clk_100M]
  connect_bd_net -net Net1 [get_bd_pins periph_resetn_clk100M] [get_bd_pins frontend/periph_resetn_clk100M]
  connect_bd_net -net PixelClk_1 [get_bd_pins PixelClk] [get_bd_pins frontend/PixelClk]
  connect_bd_net -net aclk_1 [get_bd_pins clk_142M] [get_bd_pins frontend/clk_142M]
  connect_bd_net -net hdmi_out_hpd_video_gpio_io_o [get_bd_pins hdmi_out_hpd] [get_bd_pins frontend/hdmi_out_hpd]
  connect_bd_net -net hdmi_out_hpd_video_ip2intc_irpt [get_bd_pins hdmi_out_hpd_irq] [get_bd_pins frontend/hdmi_out_hpd_irq]
  connect_bd_net -net v_tc_0_irq [get_bd_pins vtc_out_irq] [get_bd_pins frontend/vtc_out_irq]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_in
proc create_hier_cell_hdmi_in { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hdmi_in() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 DDC
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXILite
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S02_AXILite
  create_bd_intf_pin -mode Slave -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_in
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 video_out

  # Create pins
  create_bd_pin -dir O -type clk PixelClk
  create_bd_pin -dir O aPixelClkLckd
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I -type clk clk_142M
  create_bd_pin -dir I -type clk clk_200M
  create_bd_pin -dir O -from 0 -to 0 hdmi_in_hpd
  create_bd_pin -dir O -type intr hdmi_in_hpd_irq
  create_bd_pin -dir I -from 0 -to 0 -type rst periph_resetn_clk100M
  create_bd_pin -dir I -from 0 -to 0 -type rst resetn
  create_bd_pin -dir I -from 0 -to 0 -type rst vid_io_in_reset
  create_bd_pin -dir O -type intr vtc_in_irq

  # Create instance: frontend
  create_hier_cell_frontend $hier_obj frontend

  # Create interface connections
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S02_AXILite] [get_bd_intf_pins frontend/S02_AXILite]
  connect_bd_intf_net -intf_net TMDS_1 [get_bd_intf_pins TMDS_in] [get_bd_intf_pins frontend/TMDS_in]
  connect_bd_intf_net -intf_net frontend_DDC [get_bd_intf_pins DDC] [get_bd_intf_pins frontend/DDC]
  connect_bd_intf_net -intf_net frontend_video_out [get_bd_intf_pins video_out] [get_bd_intf_pins frontend/video_out]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M07_AXI [get_bd_intf_pins S00_AXILite] [get_bd_intf_pins frontend/S00_AXILite]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins clk_100M] [get_bd_pins frontend/clk_100M]
  connect_bd_net -net Net1 [get_bd_pins periph_resetn_clk100M] [get_bd_pins frontend/periph_resetn_clk100M]
  connect_bd_net -net RefClk_1 [get_bd_pins clk_200M] [get_bd_pins frontend/clk_200M]
  connect_bd_net -net aclk_1 [get_bd_pins clk_142M] [get_bd_pins frontend/clk_142M]
  connect_bd_net -net axi_gpio_video_gpio_io_o [get_bd_pins hdmi_in_hpd] [get_bd_pins frontend/hdmi_in_hpd]
  connect_bd_net -net axi_gpio_video_ip2intc_irpt [get_bd_pins hdmi_in_hpd_irq] [get_bd_pins frontend/hdmi_in_hpd_irq]
  connect_bd_net -net dvi2rgb_0_PixelClk [get_bd_pins PixelClk] [get_bd_pins frontend/PixelClk]
  connect_bd_net -net dvi2rgb_0_aPixelClkLckd [get_bd_pins aPixelClkLckd] [get_bd_pins frontend/aPixelClkLckd]
  connect_bd_net -net resetn_1 [get_bd_pins resetn] [get_bd_pins frontend/resetn]
  connect_bd_net -net v_tc_1_irq [get_bd_pins vtc_in_irq] [get_bd_pins frontend/vtc_in_irq]
  connect_bd_net -net vid_io_in_reset_1 [get_bd_pins vid_io_in_reset] [get_bd_pins frontend/vid_io_in_reset]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: VDMA_Pre
proc create_hier_cell_VDMA_Pre { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_VDMA_Pre() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 stream_in_24
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 stream_out_32

  # Create pins
  create_bd_pin -dir I -type clk clk_142M
  create_bd_pin -dir I -type rst periph_resetn_clk142M

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]

  # Create instance: color_convert_1, and set properties
  set color_convert_1 [ create_bd_cell -type ip -vlnv xilinx.com:hls:color_convert:1.0 color_convert_1 ]

  # Create instance: pixel_pack, and set properties
  set pixel_pack [ create_bd_cell -type ip -vlnv xilinx.com:hls:pixel_pack:1.0 pixel_pack ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_AXILiteS] [get_bd_intf_pins color_convert_1/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins s_axi_AXILiteS1] [get_bd_intf_pins pixel_pack/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins stream_out_32] [get_bd_intf_pins pixel_pack/stream_out_32]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins axis_register_slice_1/M_AXIS] [get_bd_intf_pins pixel_pack/stream_in_24]
  connect_bd_intf_net -intf_net axis_register_slice_2_M_AXIS [get_bd_intf_pins axis_register_slice_2/M_AXIS] [get_bd_intf_pins color_convert_1/stream_in_24]
  connect_bd_intf_net -intf_net color_convert_1_stream_out_24 [get_bd_intf_pins axis_register_slice_1/S_AXIS] [get_bd_intf_pins color_convert_1/stream_out_24]
  connect_bd_intf_net -intf_net stream_in_24_1 [get_bd_intf_pins stream_in_24] [get_bd_intf_pins axis_register_slice_2/S_AXIS]

  # Create port connections
  connect_bd_net -net clk_142M_1 [get_bd_pins clk_142M] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins color_convert_1/ap_clk] [get_bd_pins color_convert_1/control] [get_bd_pins pixel_pack/ap_clk] [get_bd_pins pixel_pack/control]
  connect_bd_net -net periph_resetn_clk142M_1 [get_bd_pins periph_resetn_clk142M] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins color_convert_1/ap_rst_n] [get_bd_pins color_convert_1/ap_rst_n_control] [get_bd_pins pixel_pack/ap_rst_n] [get_bd_pins pixel_pack/ap_rst_n_control]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: VDMA_Post
proc create_hier_cell_VDMA_Post { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_VDMA_Post() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_AXILiteS1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 stream_in_32

  # Create pins
  create_bd_pin -dir I -type clk clk_142M
  create_bd_pin -dir I -type rst periph_resetn_clk142M

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]

  # Create instance: color_convert, and set properties
  set color_convert [ create_bd_cell -type ip -vlnv xilinx.com:hls:color_convert:1.0 color_convert ]

  # Create instance: pixel_unpack, and set properties
  set pixel_unpack [ create_bd_cell -type ip -vlnv xilinx.com:hls:pixel_unpack:1.0 pixel_unpack ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins s_axi_AXILiteS] [get_bd_intf_pins pixel_unpack/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins s_axi_AXILiteS1] [get_bd_intf_pins color_convert/s_axi_AXILiteS]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins color_convert/stream_in_24]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins axis_register_slice_1/M_AXIS] [get_bd_intf_pins pixel_unpack/stream_in_32]
  connect_bd_intf_net -intf_net color_convert_stream_out_24 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins color_convert/stream_out_24]
  connect_bd_intf_net -intf_net pixel_unpack_stream_out_24 [get_bd_intf_pins axis_register_slice_0/S_AXIS] [get_bd_intf_pins pixel_unpack/stream_out_24]
  connect_bd_intf_net -intf_net stream_in_32_1 [get_bd_intf_pins stream_in_32] [get_bd_intf_pins axis_register_slice_1/S_AXIS]

  # Create port connections
  connect_bd_net -net clk_142M_1 [get_bd_pins clk_142M] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins color_convert/ap_clk] [get_bd_pins color_convert/control] [get_bd_pins pixel_unpack/ap_clk] [get_bd_pins pixel_unpack/control]
  connect_bd_net -net periph_resetn_clk142M_1 [get_bd_pins periph_resetn_clk142M] [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins color_convert/ap_rst_n] [get_bd_pins color_convert/ap_rst_n_control] [get_bd_pins pixel_unpack/ap_rst_n] [get_bd_pins pixel_unpack/ap_rst_n_control]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: video
proc create_hier_cell_video { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_video() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 DDC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI
  create_bd_intf_pin -mode Slave -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_in
  create_bd_intf_pin -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 TMDS_out

  # Create pins
  create_bd_pin -dir I -type clk clk_100M
  create_bd_pin -dir I clk_142M
  create_bd_pin -dir I -type clk clk_200M
  create_bd_pin -dir O -from 0 -to 0 hdmi_in_hpd
  create_bd_pin -dir O -from 0 -to 0 hdmi_out_hpd
  create_bd_pin -dir I -from 0 -to 0 -type rst ic_resetn_clk100M
  create_bd_pin -dir I -from 0 -to 0 -type rst ic_resetn_clk142M
  create_bd_pin -dir I -from 0 -to 0 -type rst periph_resetn_clk100M
  create_bd_pin -dir I -from 0 -to 0 -type rst periph_resetn_clk142M
  create_bd_pin -dir I -type rst system_resetn
  create_bd_pin -dir O -from 5 -to 0 video_irq

  # Create instance: HLS_Merger_0, and set properties
  set HLS_Merger_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_Merger:1.0 HLS_Merger_0 ]

  # Create instance: HLS_PR_WRAPPER_0, and set properties
  set HLS_PR_WRAPPER_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_0 ]

  # Create instance: HLS_PR_WRAPPER_1, and set properties
  set HLS_PR_WRAPPER_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_1 ]

  # Create instance: HLS_PR_WRAPPER_2, and set properties
  set HLS_PR_WRAPPER_2 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_2 ]

  # Create instance: HLS_PR_WRAPPER_3, and set properties
  set HLS_PR_WRAPPER_3 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_3 ]

  # Create instance: HLS_PR_WRAPPER_4, and set properties
  set HLS_PR_WRAPPER_4 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_4 ]

  # Create instance: HLS_PR_WRAPPER_5, and set properties
  set HLS_PR_WRAPPER_5 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_5 ]

  # Create instance: HLS_PR_WRAPPER_6, and set properties
  set HLS_PR_WRAPPER_6 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_6 ]

  # Create instance: HLS_PR_WRAPPER_7, and set properties
  set HLS_PR_WRAPPER_7 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_7 ]

  # Create instance: HLS_PR_WRAPPER_8, and set properties
  set HLS_PR_WRAPPER_8 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_8 ]

  # Create instance: HLS_PR_WRAPPER_9, and set properties
  set HLS_PR_WRAPPER_9 [ create_bd_cell -type ip -vlnv xilinx.com:user:HLS_PR_WRAPPER:1.0 HLS_PR_WRAPPER_9 ]

  # Create instance: PR_Control_0, and set properties
  set PR_Control_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:PR_Control:1.0 PR_Control_0 ]

  # Create instance: VDMA_Post
  create_hier_cell_VDMA_Post $hier_obj VDMA_Post

  # Create instance: VDMA_Pre
  create_hier_cell_VDMA_Pre $hier_obj VDMA_Pre

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M02_HAS_REGSLICE {1} \
   CONFIG.M03_HAS_REGSLICE {1} \
   CONFIG.M04_HAS_REGSLICE {1} \
   CONFIG.M05_HAS_REGSLICE {1} \
   CONFIG.M06_HAS_REGSLICE {1} \
   CONFIG.M07_HAS_REGSLICE {1} \
   CONFIG.M08_HAS_REGSLICE {1} \
   CONFIG.M09_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {13} \
   CONFIG.S00_HAS_REGSLICE {1} \
   CONFIG.STRATEGY {1} \
 ] $axi_interconnect_0

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
   CONFIG.S00_HAS_REGSLICE {1} \
   CONFIG.S01_HAS_REGSLICE {1} \
 ] $axi_mem_intercon

  # Create instance: axi_vdma, and set properties
  set axi_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma ]
  set_property -dict [ list \
   CONFIG.c_m_axi_mm2s_data_width {32} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_mm2s_genlock_mode {1} \
   CONFIG.c_mm2s_linebuffer_depth {512} \
   CONFIG.c_mm2s_max_burst_length {32} \
   CONFIG.c_num_fstores {4} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {4096} \
   CONFIG.c_s2mm_max_burst_length {32} \
 ] $axi_vdma

  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0 ]

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_0 ]

  # Create instance: axis_data_fifo_1, and set properties
  set axis_data_fifo_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_1 ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {16} \
 ] $axis_data_fifo_1

  # Create instance: axis_switch_0, and set properties
  set axis_switch_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_switch:1.1 axis_switch_0 ]
  set_property -dict [ list \
   CONFIG.DECODER_REG {1} \
   CONFIG.M00_S00_CONNECTIVITY {1} \
   CONFIG.M01_S00_CONNECTIVITY {1} \
   CONFIG.NUM_MI {15} \
   CONFIG.NUM_SI {16} \
   CONFIG.OUTPUT_REG {1} \
   CONFIG.ROUTING_MODE {1} \
 ] $axis_switch_0

  # Create instance: hdmi_in
  create_hier_cell_hdmi_in $hier_obj hdmi_in

  # Create instance: hdmi_out
  create_hier_cell_hdmi_out $hier_obj hdmi_out

  # Create instance: proc_sys_reset_pixelclk, and set properties
  set proc_sys_reset_pixelclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_pixelclk ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {6} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins TMDS_out] [get_bd_intf_pins hdmi_out/TMDS_out]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net HLS_Merger_0_M00_AXIS [get_bd_intf_pins HLS_Merger_0/M00_AXIS] [get_bd_intf_pins axis_switch_0/S02_AXIS]
  connect_bd_intf_net -intf_net HLS_Merger_0_M01_AXIS [get_bd_intf_pins HLS_Merger_0/M01_AXIS] [get_bd_intf_pins axis_switch_0/S03_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_0_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_0/M00_AXIS] [get_bd_intf_pins axis_switch_0/S04_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_1_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_1/M00_AXIS] [get_bd_intf_pins axis_switch_0/S05_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_2_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_2/M00_AXIS] [get_bd_intf_pins axis_switch_0/S06_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_3_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_3/M00_AXIS] [get_bd_intf_pins axis_switch_0/S07_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_4_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_4/M00_AXIS] [get_bd_intf_pins axis_switch_0/S08_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_5_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_5/M00_AXIS] [get_bd_intf_pins axis_switch_0/S09_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_6_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_6/M00_AXIS] [get_bd_intf_pins axis_switch_0/S10_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_7_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_7/M00_AXIS] [get_bd_intf_pins axis_switch_0/S11_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_8_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_8/M00_AXIS] [get_bd_intf_pins axis_switch_0/S12_AXIS]
  connect_bd_intf_net -intf_net HLS_PR_WRAPPER_9_M00_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_9/M00_AXIS] [get_bd_intf_pins axis_switch_0/S13_AXIS]
  connect_bd_intf_net -intf_net TMDS_1 [get_bd_intf_pins TMDS_in] [get_bd_intf_pins hdmi_in/TMDS_in]
  connect_bd_intf_net -intf_net VDMA_Post_M_AXIS [get_bd_intf_pins VDMA_Post/M_AXIS] [get_bd_intf_pins axis_switch_0/S01_AXIS]
  connect_bd_intf_net -intf_net VDMA_Pre_stream_out_32 [get_bd_intf_pins VDMA_Pre/stream_out_32] [get_bd_intf_pins axi_vdma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins axi_vdma/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins VDMA_Post/s_axi_AXILiteS] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M02_AXI [get_bd_intf_pins VDMA_Post/s_axi_AXILiteS1] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins hdmi_out/S04_AXILite]
  connect_bd_intf_net -intf_net axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins hdmi_out/S02_AXILite]
  connect_bd_intf_net -intf_net axi_interconnect_0_M05_AXI [get_bd_intf_pins axi_interconnect_0/M05_AXI] [get_bd_intf_pins hdmi_out/S00_AXILite]
  connect_bd_intf_net -intf_net axi_interconnect_0_M06_AXI [get_bd_intf_pins VDMA_Pre/s_axi_AXILiteS] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins VDMA_Pre/s_axi_AXILiteS1] [get_bd_intf_pins axi_interconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M08_AXI [get_bd_intf_pins axi_interconnect_0/M08_AXI] [get_bd_intf_pins hdmi_in/S00_AXILite]
  connect_bd_intf_net -intf_net axi_interconnect_0_M09_AXI [get_bd_intf_pins axi_interconnect_0/M09_AXI] [get_bd_intf_pins hdmi_in/S02_AXILite]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins axi_interconnect_0/M10_AXI] [get_bd_intf_pins axis_switch_0/S_AXI_CTRL]
  connect_bd_intf_net -intf_net axi_interconnect_0_M11_AXI [get_bd_intf_pins PR_Control_0/S00_AXI] [get_bd_intf_pins axi_interconnect_0/M11_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins M_AXI] [get_bd_intf_pins axi_mem_intercon/M00_AXI]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins axi_vdma/M_AXI_MM2S]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins axi_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net axi_vdma_M_AXIS_MM2S [get_bd_intf_pins VDMA_Post/stream_in_32] [get_bd_intf_pins axi_vdma/M_AXIS_MM2S]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M00_AXIS [get_bd_intf_pins axis_broadcaster_0/M00_AXIS] [get_bd_intf_pins axis_switch_0/S14_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins axis_broadcaster_0/M01_AXIS] [get_bd_intf_pins axis_switch_0/S15_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins HLS_Merger_0/S01_AXIS] [get_bd_intf_pins axis_data_fifo_0/M_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_1_M_AXIS [get_bd_intf_pins HLS_Merger_0/S00_AXIS] [get_bd_intf_pins axis_data_fifo_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M00_AXIS [get_bd_intf_pins VDMA_Pre/stream_in_24] [get_bd_intf_pins axis_switch_0/M00_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M01_AXIS [get_bd_intf_pins axis_switch_0/M01_AXIS] [get_bd_intf_pins hdmi_out/video_in]
  connect_bd_intf_net -intf_net axis_switch_0_M02_AXIS [get_bd_intf_pins axis_data_fifo_1/S_AXIS] [get_bd_intf_pins axis_switch_0/M02_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M03_AXIS [get_bd_intf_pins axis_data_fifo_0/S_AXIS] [get_bd_intf_pins axis_switch_0/M03_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M04_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_0/S00_AXIS] [get_bd_intf_pins axis_switch_0/M04_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M05_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_1/S00_AXIS] [get_bd_intf_pins axis_switch_0/M05_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M06_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_2/S00_AXIS] [get_bd_intf_pins axis_switch_0/M06_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M07_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_3/S00_AXIS] [get_bd_intf_pins axis_switch_0/M07_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M08_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_4/S00_AXIS] [get_bd_intf_pins axis_switch_0/M08_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M09_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_5/S00_AXIS] [get_bd_intf_pins axis_switch_0/M09_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M10_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_6/S00_AXIS] [get_bd_intf_pins axis_switch_0/M10_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M11_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_7/S00_AXIS] [get_bd_intf_pins axis_switch_0/M11_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M12_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_8/S00_AXIS] [get_bd_intf_pins axis_switch_0/M12_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M13_AXIS [get_bd_intf_pins HLS_PR_WRAPPER_9/S00_AXIS] [get_bd_intf_pins axis_switch_0/M13_AXIS]
  connect_bd_intf_net -intf_net axis_switch_0_M14_AXIS [get_bd_intf_pins axis_broadcaster_0/S_AXIS] [get_bd_intf_pins axis_switch_0/M14_AXIS]
  connect_bd_intf_net -intf_net frontend_DDC [get_bd_intf_pins DDC] [get_bd_intf_pins hdmi_in/DDC]
  connect_bd_intf_net -intf_net hdmi_in_video_out [get_bd_intf_pins axis_switch_0/S00_AXIS] [get_bd_intf_pins hdmi_in/video_out]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins ic_resetn_clk100M] [get_bd_pins axi_interconnect_0/ARESETN]
  connect_bd_net -net Net [get_bd_pins clk_100M] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M10_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins axi_vdma/s_axi_lite_aclk] [get_bd_pins axis_switch_0/s_axi_ctrl_aclk] [get_bd_pins hdmi_in/clk_100M] [get_bd_pins hdmi_out/clk_100M]
  connect_bd_net -net Net1 [get_bd_pins periph_resetn_clk100M] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M10_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins axi_vdma/axi_resetn] [get_bd_pins axis_switch_0/s_axi_ctrl_aresetn] [get_bd_pins hdmi_in/periph_resetn_clk100M] [get_bd_pins hdmi_out/periph_resetn_clk100M]
  connect_bd_net -net PR_Control_0_CMD [get_bd_pins HLS_Merger_0/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_0/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_1/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_2/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_3/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_4/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_5/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_6/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_7/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_8/ctl_CMD_V] [get_bd_pins HLS_PR_WRAPPER_9/ctl_CMD_V] [get_bd_pins PR_Control_0/CMD]
  connect_bd_net -net PR_Control_0_DATA [get_bd_pins HLS_Merger_0/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_0/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_1/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_2/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_3/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_4/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_5/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_6/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_7/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_8/ctl_DATA_V] [get_bd_pins HLS_PR_WRAPPER_9/ctl_DATA_V] [get_bd_pins PR_Control_0/DATA]
  connect_bd_net -net PR_Control_0_WE_0 [get_bd_pins HLS_Merger_0/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_0]
  connect_bd_net -net PR_Control_0_WE_1 [get_bd_pins HLS_PR_WRAPPER_0/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_1]
  connect_bd_net -net PR_Control_0_WE_2 [get_bd_pins HLS_PR_WRAPPER_1/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_2]
  connect_bd_net -net PR_Control_0_WE_3 [get_bd_pins HLS_PR_WRAPPER_2/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_3]
  connect_bd_net -net PR_Control_0_WE_4 [get_bd_pins HLS_PR_WRAPPER_3/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_4]
  connect_bd_net -net PR_Control_0_WE_5 [get_bd_pins HLS_PR_WRAPPER_4/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_5]
  connect_bd_net -net PR_Control_0_WE_6 [get_bd_pins HLS_PR_WRAPPER_5/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_6]
  connect_bd_net -net PR_Control_0_WE_7 [get_bd_pins HLS_PR_WRAPPER_6/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_7]
  connect_bd_net -net PR_Control_0_WE_8 [get_bd_pins HLS_PR_WRAPPER_7/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_8]
  connect_bd_net -net PR_Control_0_WE_9 [get_bd_pins HLS_PR_WRAPPER_8/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_9]
  connect_bd_net -net PR_Control_0_WE_A [get_bd_pins HLS_PR_WRAPPER_9/ctl_WR_EN_V] [get_bd_pins PR_Control_0/WE_A]
  connect_bd_net -net RefClk_1 [get_bd_pins clk_200M] [get_bd_pins hdmi_in/clk_200M]
  connect_bd_net -net aclk_1 [get_bd_pins clk_142M] [get_bd_pins HLS_Merger_0/ap_clk] [get_bd_pins HLS_PR_WRAPPER_0/ap_clk] [get_bd_pins HLS_PR_WRAPPER_1/ap_clk] [get_bd_pins HLS_PR_WRAPPER_2/ap_clk] [get_bd_pins HLS_PR_WRAPPER_3/ap_clk] [get_bd_pins HLS_PR_WRAPPER_4/ap_clk] [get_bd_pins HLS_PR_WRAPPER_5/ap_clk] [get_bd_pins HLS_PR_WRAPPER_6/ap_clk] [get_bd_pins HLS_PR_WRAPPER_7/ap_clk] [get_bd_pins HLS_PR_WRAPPER_8/ap_clk] [get_bd_pins HLS_PR_WRAPPER_9/ap_clk] [get_bd_pins PR_Control_0/s00_axi_aclk] [get_bd_pins VDMA_Post/clk_142M] [get_bd_pins VDMA_Pre/clk_142M] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M11_ACLK] [get_bd_pins axi_interconnect_0/M12_ACLK] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_vdma/m_axi_mm2s_aclk] [get_bd_pins axi_vdma/m_axi_s2mm_aclk] [get_bd_pins axi_vdma/m_axis_mm2s_aclk] [get_bd_pins axi_vdma/s_axis_s2mm_aclk] [get_bd_pins axis_broadcaster_0/aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk] [get_bd_pins axis_data_fifo_1/s_axis_aclk] [get_bd_pins axis_switch_0/aclk] [get_bd_pins hdmi_in/clk_142M] [get_bd_pins hdmi_out/clk_142M]
  connect_bd_net -net axi_gpio_video_gpio_io_o [get_bd_pins hdmi_in_hpd] [get_bd_pins hdmi_in/hdmi_in_hpd]
  connect_bd_net -net axi_gpio_video_ip2intc_irpt [get_bd_pins hdmi_in/hdmi_in_hpd_irq] [get_bd_pins xlconcat_0/In4]
  connect_bd_net -net axi_vdma_0_mm2s_introut [get_bd_pins axi_vdma/mm2s_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net axi_vdma_0_s2mm_introut [get_bd_pins axi_vdma/s2mm_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins system_resetn] [get_bd_pins proc_sys_reset_pixelclk/ext_reset_in]
  connect_bd_net -net hdmi_in_PixelClk [get_bd_pins hdmi_in/PixelClk] [get_bd_pins hdmi_out/PixelClk] [get_bd_pins proc_sys_reset_pixelclk/slowest_sync_clk]
  connect_bd_net -net hdmi_in_aPixelClkLckd [get_bd_pins hdmi_in/aPixelClkLckd] [get_bd_pins proc_sys_reset_pixelclk/aux_reset_in]
  connect_bd_net -net hdmi_out_hpd_video_gpio_io_o [get_bd_pins hdmi_out_hpd] [get_bd_pins hdmi_out/hdmi_out_hpd]
  connect_bd_net -net hdmi_out_hpd_video_ip2intc_irpt [get_bd_pins hdmi_out/hdmi_out_hpd_irq] [get_bd_pins xlconcat_0/In5]
  connect_bd_net -net proc_sys_reset_pixelclk_peripheral_aresetn [get_bd_pins hdmi_in/resetn] [get_bd_pins proc_sys_reset_pixelclk/peripheral_aresetn]
  connect_bd_net -net proc_sys_reset_pixelclk_peripheral_reset [get_bd_pins hdmi_in/vid_io_in_reset] [get_bd_pins proc_sys_reset_pixelclk/peripheral_reset]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins ic_resetn_clk142M] [get_bd_pins axi_mem_intercon/ARESETN]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins periph_resetn_clk142M] [get_bd_pins HLS_Merger_0/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_0/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_1/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_2/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_3/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_4/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_5/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_6/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_7/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_8/ap_rst_n] [get_bd_pins HLS_PR_WRAPPER_9/ap_rst_n] [get_bd_pins PR_Control_0/s00_axi_aresetn] [get_bd_pins VDMA_Post/periph_resetn_clk142M] [get_bd_pins VDMA_Pre/periph_resetn_clk142M] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M11_ARESETN] [get_bd_pins axi_interconnect_0/M12_ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn] [get_bd_pins axis_data_fifo_1/s_axis_aresetn] [get_bd_pins axis_switch_0/aresetn]
  connect_bd_net -net v_tc_0_irq [get_bd_pins hdmi_out/vtc_out_irq] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net v_tc_1_irq [get_bd_pins hdmi_in/vtc_in_irq] [get_bd_pins xlconcat_0/In3]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins video_irq] [get_bd_pins xlconcat_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set btns_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 btns_4bits ]
  set hdmi_in [ create_bd_intf_port -mode Slave -vlnv digilentinc.com:interface:tmds_rtl:1.0 hdmi_in ]
  set hdmi_in_ddc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_in_ddc ]
  set hdmi_out [ create_bd_intf_port -mode Master -vlnv digilentinc.com:interface:tmds_rtl:1.0 hdmi_out ]
  set hdmi_out_ddc [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 hdmi_out_ddc ]
  set leds_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 leds_4bits ]
  set rgbleds_6bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 rgbleds_6bits ]
  set sws_2bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 sws_2bits ]

  # Create ports
  set hdmi_in_hpd [ create_bd_port -dir O -from 0 -to 0 hdmi_in_hpd ]
  set hdmi_out_hpd [ create_bd_port -dir O -from 0 -to 0 hdmi_out_hpd ]

  # Create instance: axi_protocol_converter_0, and set properties
  set axi_protocol_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_protocol_converter:2.1 axi_protocol_converter_0 ]
  set_property -dict [ list \
   CONFIG.MI_PROTOCOL {AXI4LITE} \
 ] $axi_protocol_converter_0
  # Create instance: btns_gpio, and set properties
  set btns_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 btns_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_GPIO_WIDTH {4} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
 ] $btns_gpio

  # Create instance: concat_interrupts, and set properties
  set concat_interrupts [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_interrupts ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $concat_interrupts

  # Create instance: leds_gpio, and set properties
  set leds_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 leds_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {4} \
 ] $leds_gpio

  # Create instance: proc_sys_reset_fclk1, and set properties
  set proc_sys_reset_fclk1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_fclk1 ]

  # Create instance: ps7_0, and set properties
  set ps7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {650.000000} \
   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.096154} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {142.857132} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {650} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {26} \
   CONFIG.PCW_CAN0_BASEADDR {0xE0008000} \
   CONFIG.PCW_CAN0_CAN0_IO {<Select>} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_GRP_CLK_IO {<Select>} \
   CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN1_BASEADDR {0xE0009000} \
   CONFIG.PCW_CAN1_CAN1_IO {<Select>} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_GRP_CLK_IO {<Select>} \
   CONFIG.PCW_CAN1_HIGHADDR {0xE0009FFF} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN1_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {142857132} \
   CONFIG.PCW_CLK2_FREQ {200000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE0_IRQ_INTR {0} \
   CONFIG.PCW_CORE1_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1300.000} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {52} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {21} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1050.000} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PRIORITY_READPORT_0 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_READPORT_1 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_READPORT_2 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_READPORT_3 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2 {<Select>} \
   CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3 {<Select>} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET0_RESET_IO {<Select>} \
   CONFIG.PCW_ENET1_BASEADDR {0xE000C000} \
   CONFIG.PCW_ENET1_ENET1_IO {<Select>} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_GRP_MDIO_IO {<Select>} \
   CONFIG.PCW_ENET1_HIGHADDR {0xE000CFFF} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_RESET_IO {<Select>} \
   CONFIG.PCW_ENET_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {<Select>} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {0} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {1} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_ENET1 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {1} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {0} \
   CONFIG.PCW_EN_EMIO_SPI1 {0} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {0} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {0} \
   CONFIG.PCW_EN_GPIO {0} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_PTP_ENET0 {0} \
   CONFIG.PCW_EN_PTP_ENET1 {0} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {0} \
   CONFIG.PCW_EN_SMC {0} \
   CONFIG.PCW_EN_SPI0 {0} \
   CONFIG.PCW_EN_SPI1 {0} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {0} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {0} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {7} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {142} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_FTM_CTI_IN0 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN1 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN2 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN3 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT0 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT1 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT2 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT3 {<Select>} \
   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {<Select>} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {<Select>} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_BASEADDR {0xE0004000} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_IO {EMIO} \
   CONFIG.PCW_I2C0_HIGHADDR {0xE0004FFF} \
   CONFIG.PCW_I2C0_I2C0_IO {EMIO} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_IO {<Select>} \
   CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_GRP_INT_IO {<Select>} \
   CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
   CONFIG.PCW_I2C1_I2C1_IO {<Select>} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_IO {<Select>} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {108.333336} \
   CONFIG.PCW_I2C_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_I2C_RESET_SELECT {<Select>} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
   CONFIG.PCW_INCLUDE_TRACE_BUFFER {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {20} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_0_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_0_PULLUP {<Select>} \
   CONFIG.PCW_MIO_0_SLEW {<Select>} \
   CONFIG.PCW_MIO_10_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_10_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_10_PULLUP {<Select>} \
   CONFIG.PCW_MIO_10_SLEW {<Select>} \
   CONFIG.PCW_MIO_11_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_11_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_11_PULLUP {<Select>} \
   CONFIG.PCW_MIO_11_SLEW {<Select>} \
   CONFIG.PCW_MIO_12_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_12_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_12_PULLUP {<Select>} \
   CONFIG.PCW_MIO_12_SLEW {<Select>} \
   CONFIG.PCW_MIO_13_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_13_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_13_PULLUP {<Select>} \
   CONFIG.PCW_MIO_13_SLEW {<Select>} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {out} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_46_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_46_PULLUP {<Select>} \
   CONFIG.PCW_MIO_46_SLEW {<Select>} \
   CONFIG.PCW_MIO_47_DIRECTION {in} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_48_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_48_PULLUP {<Select>} \
   CONFIG.PCW_MIO_48_SLEW {<Select>} \
   CONFIG.PCW_MIO_49_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_49_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_49_PULLUP {<Select>} \
   CONFIG.PCW_MIO_49_SLEW {<Select>} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_50_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_50_PULLUP {<Select>} \
   CONFIG.PCW_MIO_50_SLEW {<Select>} \
   CONFIG.PCW_MIO_51_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_51_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_51_PULLUP {<Select>} \
   CONFIG.PCW_MIO_51_SLEW {<Select>} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_7_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_7_PULLUP {<Select>} \
   CONFIG.PCW_MIO_7_SLEW {<Select>} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_9_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_9_PULLUP {<Select>} \
   CONFIG.PCW_MIO_9_SLEW {<Select>} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {unassigned#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#unassigned#Quad SPI Flash#unassigned#unassigned#unassigned#unassigned#unassigned#UART 0#UART 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#unassigned#SD 0#unassigned#unassigned#unassigned#unassigned#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {unassigned#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#unassigned#qspi_fbclk#unassigned#unassigned#unassigned#unassigned#unassigned#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#unassigned#cd#unassigned#unassigned#unassigned#unassigned#mdc#mdio} \
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP1_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP1_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_CYCLES_T_AR {1} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
   CONFIG.PCW_NAND_CYCLES_T_RC {11} \
   CONFIG.PCW_NAND_CYCLES_T_REA {1} \
   CONFIG.PCW_NAND_CYCLES_T_RR {1} \
   CONFIG.PCW_NAND_CYCLES_T_WC {11} \
   CONFIG.PCW_NAND_CYCLES_T_WP {1} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_GRP_D8_IO {<Select>} \
   CONFIG.PCW_NAND_NAND_IO {<Select>} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_IO {<Select>} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_IO {<Select>} \
   CONFIG.PCW_NOR_NOR_IO {<Select>} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_P2F_CAN0_INTR {0} \
   CONFIG.PCW_P2F_CAN1_INTR {0} \
   CONFIG.PCW_P2F_CTI_INTR {0} \
   CONFIG.PCW_P2F_DMAC0_INTR {0} \
   CONFIG.PCW_P2F_DMAC1_INTR {0} \
   CONFIG.PCW_P2F_DMAC2_INTR {0} \
   CONFIG.PCW_P2F_DMAC3_INTR {0} \
   CONFIG.PCW_P2F_DMAC4_INTR {0} \
   CONFIG.PCW_P2F_DMAC5_INTR {0} \
   CONFIG.PCW_P2F_DMAC6_INTR {0} \
   CONFIG.PCW_P2F_DMAC7_INTR {0} \
   CONFIG.PCW_P2F_DMAC_ABORT_INTR {0} \
   CONFIG.PCW_P2F_ENET0_INTR {0} \
   CONFIG.PCW_P2F_ENET1_INTR {0} \
   CONFIG.PCW_P2F_GPIO_INTR {0} \
   CONFIG.PCW_P2F_I2C0_INTR {0} \
   CONFIG.PCW_P2F_I2C1_INTR {0} \
   CONFIG.PCW_P2F_QSPI_INTR {0} \
   CONFIG.PCW_P2F_SDIO0_INTR {0} \
   CONFIG.PCW_P2F_SDIO1_INTR {0} \
   CONFIG.PCW_P2F_SMC_INTR {0} \
   CONFIG.PCW_P2F_SPI0_INTR {0} \
   CONFIG.PCW_P2F_SPI1_INTR {0} \
   CONFIG.PCW_P2F_UART0_INTR {0} \
   CONFIG.PCW_P2F_UART1_INTR {0} \
   CONFIG.PCW_P2F_USB0_INTR {0} \
   CONFIG.PCW_P2F_USB1_INTR {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.223} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.212} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.085} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.092} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {0.040} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.058} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
   CONFIG.PCW_PACKAGE_NAME {clg400} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {None} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PJTAG_PJTAG_IO {<Select>} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_IO {<Select>} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SS1_IO {<Select>} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 47} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_POW_IO {<Select>} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_IO {<Select>} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_CD_IO {<Select>} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_IO {<Select>} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_IO {<Select>} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SD1_SD1_IO {<Select>} \
   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
   CONFIG.PCW_SDIO1_BASEADDR {0xE0101000} \
   CONFIG.PCW_SDIO1_HIGHADDR {0xE0101FFF} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
   CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS0_IO {<Select>} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS1_IO {<Select>} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS2_IO {<Select>} \
   CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI0_SPI0_IO {<Select>} \
   CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS0_IO {<Select>} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS1_IO {<Select>} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS2_IO {<Select>} \
   CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI1_SPI1_IO {<Select>} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {0} \
   CONFIG.PCW_S_AXI_ACP_ARUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_AWUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_ID_WIDTH {3} \
   CONFIG.PCW_S_AXI_GP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_GP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_ID_WIDTH {6} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_BUFFER_CLOCK_DELAY {12} \
   CONFIG.PCW_TRACE_BUFFER_FIFO_SIZE {128} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_16BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_IO {<Select>} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PCW_TRACE_TRACE_IO {<Select>} \
   CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC0_TTC0_IO {<Select>} \
   CONFIG.PCW_TTC1_BASEADDR {0xE0105000} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_HIGHADDR {0xE0105fff} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC1_TTC1_IO {<Select>} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_GRP_FULL_IO {<Select>} \
   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
   CONFIG.PCW_UART1_BASEADDR {0xE0001000} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_GRP_FULL_IO {<Select>} \
   CONFIG.PCW_UART1_HIGHADDR {0xE0001FFF} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART1_UART1_IO {<Select>} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {525.000000} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.223} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.212} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.085} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.092} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {25.8} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {25.8} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {80.4535} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {15.6} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {105.056} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {18.8} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {66.904} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {89.1715} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {113.63} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.040} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.058} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.009} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.033} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {16.5} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {98.503} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {18} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {68.5855} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {90.295} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {103.977} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {525} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {Custom} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {50.625} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {13.125} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {13.125} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_RESET_IO {<Select>} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_BASEADDR {0xE0103000} \
   CONFIG.PCW_USB1_HIGHADDR {0xE0103fff} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB1_RESET_IO {<Select>} \
   CONFIG.PCW_USB1_USB1_IO {<Select>} \
   CONFIG.PCW_USB_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USB_RESET_SELECT {<Select>} \
   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_CR_FABRIC {1} \
   CONFIG.PCW_USE_DDR_BYPASS {0} \
   CONFIG.PCW_USE_DEBUG {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_DMA1 {0} \
   CONFIG.PCW_USE_DMA2 {0} \
   CONFIG.PCW_USE_DMA3 {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {0} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {0} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
   CONFIG.PCW_USE_TRACE {0} \
   CONFIG.PCW_USE_TRACE_DATA_EDGE_DETECTOR {0} \
   CONFIG.PCW_VALUE_SILVERSION {3} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_WDT_WDT_IO {<Select>} \
 ] $ps7_0

  # Create instance: ps7_0_axi_periph, and set properties
  set ps7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.M00_HAS_REGSLICE {1} \
   CONFIG.M01_HAS_REGSLICE {1} \
   CONFIG.M02_HAS_REGSLICE {1} \
   CONFIG.M03_HAS_REGSLICE {1} \
   CONFIG.M04_HAS_REGSLICE {1} \
   CONFIG.M05_HAS_REGSLICE {1} \
   CONFIG.M06_HAS_REGSLICE {1} \
   CONFIG.M07_HAS_REGSLICE {1} \
   CONFIG.M08_HAS_REGSLICE {1} \
   CONFIG.M09_HAS_REGSLICE {1} \
   CONFIG.NUM_MI {6} \
   CONFIG.S00_HAS_REGSLICE {1} \
   CONFIG.STRATEGY {1} \
 ] $ps7_0_axi_periph

  # Create instance: rgbleds_gpio, and set properties
  set rgbleds_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 rgbleds_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_GPIO_WIDTH {6} \
 ] $rgbleds_gpio

  # Create instance: rst_ps7_0_fclk0, and set properties
  set rst_ps7_0_fclk0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_0_fclk0 ]

  # Create instance: switches_gpio, and set properties
  set switches_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 switches_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO2_WIDTH {32} \
   CONFIG.C_GPIO_WIDTH {2} \
   CONFIG.C_INTERRUPT_PRESENT {1} \
   CONFIG.C_IS_DUAL {0} \
 ] $switches_gpio

  # Create instance: system_interrupts, and set properties
  set system_interrupts [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 system_interrupts ]

  # Create instance: video
  create_hier_cell_video [current_bd_instance .] video

  # Create interface connections
                                                                                                                  
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins ps7_0/S_AXI_HP0] [get_bd_intf_pins video/M_AXI]
  connect_bd_intf_net -intf_net axi_protocol_converter_0_M_AXI [get_bd_intf_pins axi_protocol_converter_0/M_AXI] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net btns_gpio_GPIO [get_bd_intf_ports btns_4bits] [get_bd_intf_pins btns_gpio/GPIO]
  connect_bd_intf_net -intf_net dvi2rgb_0_DDC [get_bd_intf_ports hdmi_in_ddc] [get_bd_intf_pins video/DDC]
  connect_bd_intf_net -intf_net gpio_leds_GPIO [get_bd_intf_ports leds_4bits] [get_bd_intf_pins leds_gpio/GPIO]
  connect_bd_intf_net -intf_net hdmi_in_1 [get_bd_intf_ports hdmi_in] [get_bd_intf_pins video/TMDS_in]
  connect_bd_intf_net -intf_net ps7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins ps7_0/DDR]
  connect_bd_intf_net -intf_net ps7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins ps7_0/FIXED_IO]
  connect_bd_intf_net -intf_net ps7_0_IIC_0 [get_bd_intf_ports hdmi_out_ddc] [get_bd_intf_pins ps7_0/IIC_0]
  connect_bd_intf_net -intf_net ps7_0_M_AXI_GP0 [get_bd_intf_pins axi_protocol_converter_0/S_AXI] [get_bd_intf_pins ps7_0/M_AXI_GP0]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins btns_gpio/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins leds_gpio/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins ps7_0_axi_periph/M02_AXI] [get_bd_intf_pins rgbleds_gpio/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins ps7_0_axi_periph/M03_AXI] [get_bd_intf_pins switches_gpio/S_AXI]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins ps7_0_axi_periph/M04_AXI] [get_bd_intf_pins system_interrupts/s_axi]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M05_AXI [get_bd_intf_pins ps7_0_axi_periph/M05_AXI] [get_bd_intf_pins video/S_AXI]
  connect_bd_intf_net -intf_net rgbled_gpio_GPIO [get_bd_intf_ports rgbleds_6bits] [get_bd_intf_pins rgbleds_gpio/GPIO]
  connect_bd_intf_net -intf_net swsleds_gpio_GPIO [get_bd_intf_ports sws_2bits] [get_bd_intf_pins switches_gpio/GPIO]
  connect_bd_intf_net -intf_net video_TMDS1 [get_bd_intf_ports hdmi_out] [get_bd_intf_pins video/TMDS_out]
  connect_bd_intf_net -intf_net rgbled_gpio_GPIO [get_bd_intf_ports rgbleds_6bits] [get_bd_intf_pins rgbleds_gpio/GPIO]
  connect_bd_intf_net -intf_net swsleds_gpio_GPIO [get_bd_intf_ports sws_2bits] [get_bd_intf_pins switches_gpio/GPIO]
  connect_bd_intf_net -intf_net video_TMDS1 [get_bd_intf_ports hdmi_out] [get_bd_intf_pins video/TMDS_out]

  # Create port connections
  connect_bd_net -net axi_gpio_video_gpio_io_o [get_bd_ports hdmi_in_hpd] [get_bd_pins video/hdmi_in_hpd]
  connect_bd_net -net btns_gpio_ip2intc_irpt [get_bd_pins btns_gpio/ip2intc_irpt] [get_bd_pins concat_interrupts/In1]
  connect_bd_net -net concat_interrupts_dout [get_bd_pins concat_interrupts/dout] [get_bd_pins system_interrupts/intr]
  connect_bd_net -net hdmi_out_hpd_video_gpio_io_o [get_bd_ports hdmi_out_hpd] [get_bd_pins video/hdmi_out_hpd]
  connect_bd_net -net iop_interrupts_irq [get_bd_pins ps7_0/IRQ_F2P] [get_bd_pins system_interrupts/irq]
  connect_bd_net -net proc_sys_reset_fclk1_interconnect_aresetn [get_bd_pins proc_sys_reset_fclk1/interconnect_aresetn] [get_bd_pins video/ic_resetn_clk142M]
  connect_bd_net -net proc_sys_reset_fclk1_peripheral_aresetn [get_bd_pins proc_sys_reset_fclk1/peripheral_aresetn] [get_bd_pins video/periph_resetn_clk142M]
  connect_bd_net -net ps7_0_FCLK_CLK0 [get_bd_pins axi_protocol_converter_0/aclk] [get_bd_pins btns_gpio/s_axi_aclk] [get_bd_pins leds_gpio/s_axi_aclk] [get_bd_pins ps7_0/FCLK_CLK0] [get_bd_pins ps7_0/M_AXI_GP0_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/M05_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rgbleds_gpio/s_axi_aclk] [get_bd_pins rst_ps7_0_fclk0/slowest_sync_clk] [get_bd_pins switches_gpio/s_axi_aclk] [get_bd_pins system_interrupts/s_axi_aclk] [get_bd_pins video/clk_100M]
  connect_bd_net -net ps7_0_FCLK_CLK1 [get_bd_pins proc_sys_reset_fclk1/slowest_sync_clk] [get_bd_pins ps7_0/FCLK_CLK1] [get_bd_pins ps7_0/S_AXI_HP0_ACLK] [get_bd_pins video/clk_142M]
  connect_bd_net -net ps7_0_FCLK_CLK2 [get_bd_pins ps7_0/FCLK_CLK2] [get_bd_pins video/clk_200M]
  connect_bd_net -net ps7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_fclk1/ext_reset_in] [get_bd_pins ps7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_fclk0/ext_reset_in] [get_bd_pins video/system_resetn]
  connect_bd_net -net rst_ps7_0_fclk0_interconnect_aresetn [get_bd_pins axi_protocol_converter_0/aresetn] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins rst_ps7_0_fclk0/interconnect_aresetn] [get_bd_pins video/ic_resetn_clk100M]
  connect_bd_net -net rst_ps7_0_fclk0_peripheral_aresetn [get_bd_pins btns_gpio/s_axi_aresetn] [get_bd_pins leds_gpio/s_axi_aresetn] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/M05_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rgbleds_gpio/s_axi_aresetn] [get_bd_pins rst_ps7_0_fclk0/peripheral_aresetn] [get_bd_pins switches_gpio/s_axi_aresetn] [get_bd_pins system_interrupts/s_axi_aresetn] [get_bd_pins video/periph_resetn_clk100M]
  connect_bd_net -net switches_gpio_ip2intc_irpt [get_bd_pins concat_interrupts/In2] [get_bd_pins switches_gpio/ip2intc_irpt]
  connect_bd_net -net video_dout [get_bd_pins concat_interrupts/In0] [get_bd_pins video/video_irq]

  # Create address segments
  create_bd_addr_seg -range 0x00010000 -offset 0x43C80000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/PR_Control_0/S00_AXI/S00_AXI_reg] SEG_PR_Control_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/hdmi_out/frontend/axi_dynclk/s00_axi/reg0] SEG_axi_dynclk_reg0
  create_bd_addr_seg -range 0x00010000 -offset 0x41220000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/hdmi_in/frontend/axi_gpio_hdmiin/S_AXI/Reg] SEG_axi_gpio_hdmiin_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43000000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/axi_vdma/S_AXI_LITE/Reg] SEG_axi_vdma_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/axis_switch_0/S_AXI_CTRL/Reg] SEG_axis_switch_0_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41210000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs btns_gpio/S_AXI/Reg] SEG_btns_gpio_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C50000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/VDMA_Pre/color_convert_1/s_axi_AXILiteS/Reg] SEG_color_convert_1_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C60000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/VDMA_Post/color_convert/s_axi_AXILiteS/Reg] SEG_color_convert_Reg1
  create_bd_addr_seg -range 0x00010000 -offset 0x41230000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/hdmi_out/frontend/hdmi_out_hpd_video/S_AXI/Reg] SEG_hdmi_out_hpd_video_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41250000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs leds_gpio/S_AXI/Reg] SEG_leds_gpio_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C40000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/VDMA_Pre/pixel_pack/s_axi_AXILiteS/Reg] SEG_pixel_pack_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C70000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/VDMA_Post/pixel_unpack/s_axi_AXILiteS/Reg] SEG_pixel_unpack_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41240000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs rgbleds_gpio/S_AXI/Reg] SEG_rgbleds_gpio_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41200000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs switches_gpio/S_AXI/Reg] SEG_swsleds_gpio_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x41800000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs system_interrupts/S_AXI/Reg] SEG_system_interrupts_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C30000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/hdmi_in/frontend/vtc_in/ctrl/Reg] SEG_vtc_in_Reg
  create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces ps7_0/Data] [get_bd_addr_segs video/hdmi_out/frontend/vtc_out/ctrl/Reg] SEG_vtc_out_Reg
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces video/axi_vdma/Data_MM2S] [get_bd_addr_segs ps7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces video/axi_vdma/Data_S2MM] [get_bd_addr_segs ps7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps7_0_HP0_DDR_LOWOCM


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()

##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

# Additional steps to get to bitstream
# Add top wrapper and xdc files
add_files -norecurse ./vivado/bare_top.v
update_compile_order -fileset sources_1
set_property top top [current_fileset]
update_compile_order -fileset sources_1
add_files -fileset constrs_1 -norecurse ./vivado/constraints/top.xdc
update_compile_order -fileset sources_1
set_property strategy Flow_AlternateRoutability [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY full [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.RETIMING true [get_runs synth_1]
launch_runs synth_1 -jobs 4
wait_on_run synth_1
open_run synth_1 -name synth_1
write_checkpoint -force ../../drp/Static/top.dcp
close_project

puts "Done!"
