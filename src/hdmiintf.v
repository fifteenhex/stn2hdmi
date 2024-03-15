module hdmiintf
#(
    parameter HORIZONTAL_PIXELS = 1040,
              HORIZONTAL_FRONT_PORCH = 56,
              HORIZONTAL_SYNC_PULSE = 120,
              HORIZONTAL_BACK_PORCH = 64,
              HORIZONTAL_POL = 1'b1,
              VERTICAL_LINES = 666,
              VERTICAL_FRONT_PORCH = 37,
              VERTICAL_SYNC_PULSE = 6,
              VERTICAL_BACK_PORCH = 23,
              VERTICAL_POL = 1'b1
)
(
    input logic clk_in,

    // Outputs to HDMI PMOD
    output logic [2:0] rgb,
    output logic clk_out,
    output logic de,
    output logic vs,
    output logic hs,

    // Pixel data connection
    output logic [9:0] x,
    output logic [9:0] y,
    input logic [2:0] pixel_data
);

    reg [15:0] counter_horizontal = 0;
    reg [15:0] counter_vertical = 0;

    assign clk_out = clk_in;

    int horizontal_sync_start;
    int horizontal_sync_end;
    int horizontal_active_start;
    int vertical_sync_start;
    int vertical_sync_end;
    int vertical_active_start;

    assign horizontal_sync_start = HORIZONTAL_FRONT_PORCH;
    assign horizontal_sync_end = (HORIZONTAL_FRONT_PORCH + HORIZONTAL_SYNC_PULSE);    
    assign horizontal_active_start = (HORIZONTAL_FRONT_PORCH + HORIZONTAL_SYNC_PULSE + HORIZONTAL_BACK_PORCH);
    assign vertical_sync_start = VERTICAL_FRONT_PORCH;
    assign vertical_sync_end = (VERTICAL_FRONT_PORCH + VERTICAL_SYNC_PULSE);    
    assign vertical_active_start = (VERTICAL_FRONT_PORCH + VERTICAL_SYNC_PULSE + VERTICAL_BACK_PORCH);

    always @(posedge clk_in) begin
        // 1. active area control
        // Raise DE when in the active area
        if ((counter_vertical >= vertical_active_start) &&
            (counter_horizontal >= horizontal_active_start))
            begin
                de <= 1'b1;
                rgb <= pixel_data;

                x <= counter_horizontal - horizontal_active_start;
                y <= counter_vertical - vertical_active_start;
            end
        else
            begin
                de <= 1'b0;
                rgb <= 3'b111;
                x <= 0;
                y <= 0;
            end

        // 2. sync pulse generation
        // Generate horizontal sync pulse
        if(counter_horizontal >= horizontal_sync_start &&
            counter_horizontal < horizontal_sync_end)
            hs <= HORIZONTAL_POL;
        else
            hs <= ~HORIZONTAL_POL;

        // Generate vertical sync pulse
        if((counter_vertical >= vertical_sync_start) &&
            (counter_vertical < vertical_sync_end))
            vs <= VERTICAL_POL;
        else
            vs <= ~VERTICAL_POL;

        // 3. horizontal and vertical counter update
        // Reset horizontal counter, and increment vertical counter at end of line
        if (counter_horizontal == (HORIZONTAL_PIXELS - 1))
        begin
            counter_horizontal <= 0;

            // Reset the vertical counter and pixel at the end of frame
            if (counter_vertical == (VERTICAL_LINES - 1))
                    counter_vertical <= 0;
            else
                // Otherwise next line
                counter_vertical <= counter_vertical + 1;
        end
        // Otherwise next pixel
        else
            counter_horizontal <= counter_horizontal + 1;
    end

endmodule