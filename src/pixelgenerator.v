module pixelgenerator
(
    input clk,

    // pixel data connection 
    input logic [9:0] x,
    input logic [9:0] y,
    input logic x_sync,
    input logic y_sync,
    output logic [2:0] pixel_data,

    // framebuffer connection
    output logic [18:0] fb_addr,
    input logic fb_data,

    input logic dbg_line,
    input logic dbg_frame,
    input logic [3:0] dbg_pixelbus,
    input logic [9:0] dbg_frame_width,
    input logic [8:0] dbg_frame_height,
    input logic [9:0] dbg_frame_x,
    input logic [8:0] dbg_frame_y
);

    wire logic [32:0] lineaddress;

    lineaddresscounter lineaddresscounter (
        .x_sync(x_sync),
        .y_sync(y_sync),
        .linewidth(dbg_frame_width),
        .counter(lineaddress)
    );

    always @(posedge clk) begin
        if ((x < dbg_frame_width) && (y < dbg_frame_height))
            begin
                //fb_addr <= lineaddress + x;
                fb_addr <= x;
                case (fb_data)
                    1'b0: pixel_data <= 3'b100;
                    1'b1: pixel_data <= 3'b111;
                endcase
            end
        else
            begin
                fb_addr <= 0;
                pixel_data <= 3'b000;
            end
        //else if ((y == 10 && x == 10) && !dbg_frame)
        //    pixel_data <= 3'b010;
        //else if ((y == 20 && x == 10) && !dbg_line)
        //    pixel_data <= 3'b010;
        //else if (((y >= 30 && x >= 10) &&  (y <= 40 && x <= 20)) && dbg_pixelbus[0])
        //    pixel_data <= 3'b010;
        //else if (((y >= 40 && x >= 10) && (y <= 50 && x <= 20)) && dbg_pixelbus[1])
        //    pixel_data <= 3'b010;
        //else if (((y >= 50 && x >= 10) && (y <= 60 && x <= 20)) && dbg_pixelbus[2])
        //    pixel_data <= 3'b010;
        //else if (((y >= 60 && x >= 10) && (y <= 70 && x <= 20)) && dbg_pixelbus[3])
        //    pixel_data <= 3'b010;
        //if (y == dbg_frame_y)
       //     pixel_data <= 3'b001;
        //if (x == dbg_frame_x)
        //    pixel_data <= 3'b001;
       // else
            //begin

            //end
        //if (x_sync)
        //    pixel_data <= 3'b010;
        //if (y_sync)
        //    pixel_data <= 3'b001;
        
        /* debugging */
        if ((!x[3:0]) || (!y[3:0])) 
            pixel_data <= 3'b001;
    end
endmodule