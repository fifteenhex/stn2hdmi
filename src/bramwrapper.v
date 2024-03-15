module bramwrapper
#(
    parameter BLOCK = 0
)
(
    input logic in_clk,
    input logic in_bank,
    input logic [2:0] in_block,
    input logic [11:0] in_addr,
    input logic [3:0] in_data,

    input logic out_clk,
    input logic out_bank,
    input logic [2:0] out_block,
    input logic [13:0] out_addr,
    output logic out_data
);

    wire logic [30:0] do_discard;

    SDPB #(.READ_MODE(1'b1), .BIT_WIDTH_0(4), .BIT_WIDTH_1(1), .BLK_SEL_0(BLOCK), .BLK_SEL_1(BLOCK), .RESET_MODE("ASYNC"))
        bram (
        // port a
        .CLKA(in_clk),
        .CEA(in_bank),
        .ADA({in_addr, 2'b00}),
        .BLKSELA(in_block),
        .DI({{28{1'b0}},in_data}),
        // port b
        .CLKB(out_clk),
        .CEB(out_bank),
        .RESET(1'b0),
        .OCE(1'b1),
        .BLKSELB(out_block),
        .ADB(out_addr),
        .DO({do_discard,out_data})
    );

endmodule