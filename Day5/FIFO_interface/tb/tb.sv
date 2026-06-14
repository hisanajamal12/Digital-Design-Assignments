`timescale 1ns/1ps

module fifo_tb;

    logic clk;

    // Interface instance
    fifo_if inf(clk);

    // DUT instance
    fifo dut(inf);

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Init
        clk = 0;
        inf.rst   = 1;
        inf.wrenb = 0;
        inf.rdenb = 0;
        inf.data_in = 0;

        // Reset
        #10 inf.rst = 0;

        // WRITE
        inf.wrenb = 1;
        inf.data_in = 8'hAA; #10;
        inf.data_in = 8'hBB; #10;
        inf.data_in = 8'hCC; #10;
        inf.wrenb = 0;

        #20;

        // READ
        inf.rdenb = 1;
        #30;
        inf.rdenb = 0;

        #20;

        // FILL FIFO
        inf.wrenb = 1;
        inf.data_in = 8'h01; #10;
        inf.data_in = 8'h02; #10;
        inf.data_in = 8'h03; #10;
        inf.data_in = 8'h04; #10;
        inf.data_in = 8'h05; #10;
        inf.data_in = 8'h06; #10;
        inf.data_in = 8'h07; #10;
        inf.wrenb = 0;

        #20;

        // EMPTY FIFO
        inf.rdenb = 1;
        #80;
        inf.rdenb = 0;

        #20;
        $finish;
    end

endmodule
