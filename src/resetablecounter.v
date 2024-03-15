module latchingcounter
#(
    parameter INCREMENT = 1
)
(
    input logic clk,
    input logic rst,
    output logic [31:0] count,
    output logic [31:0] counter
);

    always @(posedge clk) begin
        if (rst)
            begin
            count <= counter;
            counter <= 0;
            end
        else
            counter <= counter + INCREMENT;
    end

endmodule