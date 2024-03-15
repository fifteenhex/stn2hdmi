module lineaddresscounter
(
    input logic [15:0] linewidth, 
    input logic x_sync,
    input logic y_sync,    
    output logic [32:0] counter
);

    always @(posedge x_sync) begin
        if(y_sync)
            counter <= 0;
        else
            counter <= counter + linewidth;            
    end

endmodule