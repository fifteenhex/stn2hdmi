//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.9.01
//Part Number: GW5A-LV25MG121NES
//Device: GW5A-25
//Device Version: A
//Created Time: Wed Mar  6 22:13:06 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    framebuffer_sdpb your_instance_name(
        .dout(dout_o), //output [0:0] dout
        .clka(clka_i), //input clka
        .cea(cea_i), //input cea
        .clkb(clkb_i), //input clkb
        .ceb(ceb_i), //input ceb
        .oce(oce_i), //input oce
        .reset(reset_i), //input reset
        .ada(ada_i), //input [16:0] ada
        .din(din_i), //input [3:0] din
        .adb(adb_i) //input [18:0] adb
    );

//--------Copy end-------------------
