module dblcdintf
(
    // Signals from the DragonBall LCDC
    input logic lflm,
    input logic llp,
    input logic lck,
    input logic [3:0] ld,

    // Frame information
    output logic [9:0] frame_width,
    output logic [8:0] frame_height,
    output logic [9:0] frame_x,
    output logic [8:0] frame_y,

    // Basically LD..
    output logic [3:0] data_out
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

    always @(posedge lck) begin
        //if (frame_x > 300 && frame_y < 256)
        //    data_out <= 4'b1111;
        //else
        //    data_out <= 0;
        data_out[0] <= ld[3];
        data_out[1] <= ld[2];
        data_out[2] <= ld[1];
        data_out[3] <= ld[0];
    end

endmodule
