z//Copyright (C)2014-2025 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.11.02 (64-bit)
//Part Number: GW1NR-UV9QN88PC6/I5
//Device: GW1NR-9
//Device Version: C
//Created Time: Tue Jul  8 00:07:28 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Pll_Top your_instance_name(
        .clkout(clkout), //output clkout
        .lock(lock), //output lock
        .reset(reset), //input reset
        .clkin(clkin) //input clkin
    );

//--------Copy end-------------------