//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.9.01 
//Created Time: 2024-03-06 23:24:51
create_clock -name ext_clk_50 -period 20 -waveform {0 10} [get_ports {ext_clk}]
