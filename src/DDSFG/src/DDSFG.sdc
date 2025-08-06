//Copyright (C)2014-2025 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.11.01 (64-bit) 
//Created Time: 2025-07-28 14:36:16
create_clock -name CLK_27M -period 37.037 -waveform {0 18.518} [get_ports {Ext_Clk}]
create_clock -name CLK_PLL -period 20.833 -waveform {0 10.416} [get_pins {m_pll/rpll_inst/CLKOUT}]
create_generated_clock -name CLK_24M -source [get_pins {m_pll/rpll_inst/CLKOUT}] -master_clock CLK_PLL -divide_by 2 [get_pins {m_clk_div/rFg_Clk_s0/Q}]
set_false_path -from [get_clocks {CLK_27M}] -to [get_clocks {CLK_24M}] 
set_false_path -from [get_clocks {CLK_27M}] -to [get_clocks {CLK_PLL}] 
set_false_path -from [get_clocks {CLK_24M}] -to [get_clocks {CLK_27M}] 
set_false_path -from [get_clocks {CLK_PLL}] -to [get_clocks {CLK_27M}] 
