module framebuffer
(
    // input side
    input logic in_clk,
    /* Max vertical resolution is 512 lines */
    input logic [8:0] in_y,
    /* Max horizontal resolution is 1024 pixels */
    input logic [9:0] in_x,
    /* 4 pixels at a time */
    input logic [3:0] in_data,
    
    // output side
    input logic out_clk,
    input logic [8:0] out_y,
    input logic [9:0] out_x,
    output logic out_data
);

    reg [3:0] in_bank;
    wire logic [2:0] in_block;
    wire logic [11:0] in_addr;
    reg [3:0] out_bank;
    wire logic [2:0] out_block;
    wire logic [13:0] out_addr;
    wire logic [3:0] out_bank_data [7:0];

    genvar i;
    genvar j;
    generate
        for (i = 0; i < 4; i++) begin : bram_banks
            for (j = 0; j < 8; j++) begin : bram_blocks
                bramwrapper #(.BLOCK(j)) inst (
                    .in_clk(in_clk),
                    .in_bank(in_bank[i]),
                    .in_block(in_block),
                    .in_addr(in_addr),
                    .in_data(in_data),
                    .out_clk(out_clk),
                    .out_bank(out_bank[i]),
                    .out_block(out_block),
                    .out_addr(out_addr),
                    .out_data(out_bank_data[j][i])
                );
            end
        end
    endgenerate

    always @(posedge in_clk) begin
        // 4 banks of BRAM banks
        case (in_y[8:7])
            2'b00: in_bank <= 4'b0001;
            2'b01: in_bank <= 4'b0010;
            2'b10: in_bank <= 4'b0100;
            2'b11: in_bank <= 4'b1000;
        endcase        
    end

    always @(posedge out_clk) begin
        // 4 banks of BRAM banks
        case (out_y[8:7])
            2'b00: out_bank <= 4'b0001;
            2'b01: out_bank <= 4'b0010;
            2'b10: out_bank <= 4'b0100;
            2'b11: out_bank <= 4'b1000;
        endcase        
    end

    // 8 BRAMs per bank
    assign in_block = in_y[6:4];
    /* 
     * There are 16Kbit per bram, so 16 1024 pixel lines
     * this means that the bottom four bits of the current in y
     * select the line in a single bram */
    assign in_addr[11:8] = in_y[3:0];
    assign in_addr[7:0] = in_x[9:2];

    assign out_block = out_y[6:4];
    assign out_addr[13:10] = out_y[3:0];
    assign out_addr[9:0] = out_x;

    assign out_data = out_bank_data[out_block][out_y[8:7]];

endmodule