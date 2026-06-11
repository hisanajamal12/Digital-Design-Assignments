`timescale 1ns/1ps

module bmg_tb;

reg clk;
reg rstn;
reg wrenb;
reg [2:0] wradd;
reg [2:0] rdadd;
reg [7:0] data_in;
wire [7:0] data_out;

block_mem_generator dut (
    clk, rstn, wrenb,
    wradd, rdadd,
    data_in, data_out
);

// Clock generation
always #5 clk = ~clk;

initial begin
    // Initialize
    clk = 0;
    rstn = 0;
    wrenb = 0;
    wradd = 0;
    rdadd = 0;
    data_in = 0;

    // Reset
    #10 rstn = 1;

    // WRITE operations
    #10 wrenb = 1; wradd = 3'd5; data_in = 8'hB9;
    #10 wradd = 3'd3; data_in = 8'hBB;

    // READ operations
    #10 wrenb = 0; rdadd = 3'd5;
    #10 rdadd = 3'd3;

    // Finish
    #20 $finish;
end

// Monitor values
initial begin
    $monitor("Time=%0t | wrenb=%b | wradd=%d | rdadd=%d | data_in=%h | data_out=%h",
              $time, wrenb, wradd, rdadd, data_in, data_out);
end

endmodule
