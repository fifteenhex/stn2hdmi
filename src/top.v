module top
(
    input logic ext_clk,
    input logic [1:0] buttons,
    // HDMI encoder signals
    output [2:0] hdmi_rgb,
    output hdmi_clk,
    output hdmi_de,
    output hdmi_vs,
    output hdmi_hs,
    /* db lcd interface */
    input logic [3:0] db_ld,
    input logic db_lflm,
    input logic db_llp,
    input logic db_lck 
);

    wire logic [3:0] db_data_out;
    wire logic [31:0] db_addr_out;

    // pixel data connections between pixelgenerator and hdmi
    wire logic [9:0] x;
    wire logic [9:0] y;
    wire logic x_sync;
    wire logic y_sync;
    wire logic [2:0] pixel_data;

    // framebuffer connections between pixelgenerator and fb
    wire logic [18:0] pixelgenerator_fb_addr;
    wire logic pixelgenerator_fb_data;

    // dbg connections between db lcd intf and pixelgenerator
    wire logic [9:0] frame_width;
    wire logic [8:0] frame_height;
    wire logic [9:0] frame_x;
    wire logic [8:0] frame_y;

    framebuffer_sdpb framebuffer_sdpb_inst(
        .clka(db_lck),     //input clka
        .oce(1'b0),            //input oce
        .reset(1'b0),          //input reset
        .ada(db_addr_out),  //input [16:0] ada
        .cea(1'b1),            //input cea
        .din(db_data_out),  //input [3:0] din
        .clkb(ext_clk),     //input clkb
        .adb(pixelgenerator_fb_addr),//input [18:0] adb
        .ceb(1'b1),            //input ceb
        .dout(pixelgenerator_fb_data) //output [0:0] dout
    );

    pixelgenerator pixelgenerator_inst(
        .clk(ext_clk),
        // pixel connections
        .x(x),
        .y(y),
        .x_sync(x_sync),
        .y_sync(y_sync),
        .pixel_data(pixel_data),
        // framebuffer connections
        .fb_addr(pixelgenerator_fb_addr),
        .fb_data(pixelgenerator_fb_data),
        // dbg
        .dbg_line(db_llp),
        .dbg_frame(db_lflm),
        .dbg_pixelbus(db_ld),
        .dbg_frame_width(frame_width),
        .dbg_frame_height(frame_height),
        .dbg_frame_x(frame_x),
        .dbg_frame_y(frame_y)
    );

    hdmiintf hdmiintf_inst(
        .clk_in(ext_clk),
        .rgb(hdmi_rgb),
        .clk_out(hdmi_clk),
        .de(hdmi_de),
        .vs(hdmi_vs),
        .hs(hdmi_hs),
        // pixel data connections
        .x(x),
        .y(y),
        .x_sync(x_sync),
        .y_sync(y_sync),
        .pixel_data(pixel_data)
    );

    dblcdintf dblcdintf_inst(
        // Inputs from DragonBall LCDC
        .lflm(db_lflm),
        .llp(db_llp),
        .lck(db_lck),
        .ld(db_ld),
        // Outputs
        .addr_out(db_addr_out),
        .data_out(db_data_out),
        .frame_width(frame_width),
        .frame_height(frame_height),
        .frame_x(frame_x),
        .frame_y(frame_y)
    );

endmodule