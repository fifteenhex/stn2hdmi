module hdmiintf_test
#(
    CLOCK_PERIOD = 10
);

reg pixel_clk;


always #(CLOCK_PERIOD/2) pixel_clk = ~pixel_clk;

hdmiintf uut(
    .clk_in(pixel_clk)
);

initial begin
    $dumpfile("hdmiintf.vcd");
    $dumpvars(0,pixel_clk);
    $dumpvars(1,uut);

    pixel_clk <= 0;

    for (int i = 0; i < (800*600); i = i + 1) begin
        @(posedge pixel_clk);
    end

    $finish;
end

endmodule
れ
