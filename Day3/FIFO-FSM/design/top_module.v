module top_module(
    input clk,
    input rst,
    input [7:0] data_in,
    input wrenb,
    input rdenb,
    output [2:0] out
);

wire [7:0] fifo_out;
wire full, empty;

// FIFO instance
fifo_ f1 (
    .clk(clk),
    .rst(rst),
    .wrenb(wrenb),
    .rdenb(rdenb),
    .data_in(data_in),
    .data_out(fifo_out),
    .full(full),
    .empty(empty)
);

// FSM instance
mod_out f2 (
    .clk(clk),
    .rst(rst),
    .din(fifo_out),
    .out(out)
);

endmodule
