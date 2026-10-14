//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.10.03 Education (64-bit)
//Part Number: GW1NSR-LV4CQN48PC6/I5
//Device: GW1NSR-4C
//Created Time: Sat Mar  8 16:47:48 2025

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    TMDS_PLLVR your_instance_name(
        .clkout(clkout), //output clkout
        .lock(lock), //output lock
        .clkoutd(clkoutd), //output clkoutd
        .clkin(clkin) //input clkin
    );

//--------Copy end-------------------
