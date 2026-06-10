module top_tb();

reg clk, rst;
reg [7:0] data_in;
reg wrenb, rdenb;
wire [2:0] out;

top_module dut(clk, rst, data_in, wrenb, rdenb, out);

// clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    wrenb = 0;
    rdenb = 0;
    data_in = 0;

    #10 rst = 0;

    // WRITE DATA INTO FIFO
    wrenb = 1;
    repeat(10)
    begin
        #10 data_in = $random;
    end
    wrenb = 0;

    // READ DATA FROM FIFO
    #20 rdenb = 1;

    #200 $finish;
end

endmodule
