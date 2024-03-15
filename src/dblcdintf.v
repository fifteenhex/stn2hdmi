module dblcdintf
(
    // Signals from the DragonBall LCDC
    input logic lflm,
    input logic llp,
    input logic lck,
    input logic [3:0] ld,

    // Connection to framebuffer
    output logic [31:0] addr_out,
    output logic [3:0] data_out,

    // Frame information
    output logic [9:0] frame_width,
    output logic [8:0] frame_height,
    output logic [9:0] frame_x,
    output logic [8:0] frame_y
);

    latchingcounter counter_line (
        .clk(llp),
        .rst(lflm),
        .count(frame_height),
        .counter(frame_y)
    );

    latchingcounter #(.INCREMENT(4)) counter_pixel (
        .clk(lck | llp),
        .rst(llp),
        .count(frame_width),
        .counter(frame_x)
    );

    latchingcounter counter_frame_pixel (
        .clk(lck | lflm),
        .rst(lflm),
        .counter(addr_out)
    );

    always @(posedge lck) begin
        //addr_out <= (128 * ((16 * 10) + 8)) + (4 * 1) + 3;
        if (frame_y < 256)
            data_out <= 4'b1111;
        else
            data_out <= 0;
    end

endmodule