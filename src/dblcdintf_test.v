module dblcdintf_test
#(
    CLOCK_PERIOD = 10
);

reg ext_clk;
reg lflm;
reg llp;
reg lck;
reg [3:0] ld;

always #(CLOCK_PERIOD/2) ext_clk = ~ext_clk;

dblcdintf uut(
    .lflm(lflm),
    .llp(llp),
    .lck(lck),
    .ld(ld)
);

initial begin
    $dumpfile("dblcdintf.vcd");
    $dumpvars(0,ext_clk);
    $dumpvars(1,uut);

    ext_clk <= 0;
    lflm <= 0;
    llp <= 0;
    lck <= 0;


    for (int frame = 0; frame < 4; frame = frame + 1) begin
        for (int line = 0; line < 32; line = line + 1) begin
            for (int i=0; i<65; i=i+1) begin
                @(posedge ext_clk);
                if (i < 64)
                    lck <= ~lck;
                else
                    lck <= 0;

                if(i == 64) begin
                    @(posedge ext_clk);
                    llp <= 1;
                    @(posedge ext_clk);
                    @(posedge ext_clk);
                    llp <= 0;
                    @(posedge ext_clk);
                end
            end

            if(line == 31)
                lflm <= 1;
            else
                lflm <= 0;
        end
    end

    $finish;
end

endmodule
れ
