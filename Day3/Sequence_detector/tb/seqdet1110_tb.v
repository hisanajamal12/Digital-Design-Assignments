module seqdet1110_tb();


reg clk_tb, rst_tb, din_tb;
wire detected_tb;

seqdet1110 dut(clk_tb, rst_tb, din_tb, detected_tb);

// clock
initial
begin
    clk_tb = 0;
    forever #5 clk_tb = ~clk_tb;
end

// stimulus
initial
begin
    $monitor("time=%0t din=%b detected=%b", $time, din_tb, detected_tb);

    rst_tb = 1; din_tb = 0;
    #10 rst_tb = 0;

    // TEST: 1 1 1 0 ? detect
    #10 din_tb = 1;
    #10 din_tb = 1;
    #10 din_tb = 1;
    #10 din_tb = 0;

    // OVERLAP TEST: 1 1 1 1 0 ? should detect again
    #10 din_tb = 1;
    #10 din_tb = 1;
    #10 din_tb = 1;
    #10 din_tb = 1;
    #10 din_tb = 0;

    #20 $finish;
end

endmodule
