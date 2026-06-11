module block_mem_generator(
    input clk, arstn, wr_enb,
    input [2:0] wr_ad, rd_add,
    input [7:0] d_in,
    output reg [7:0] d_out
);

reg [7:0] mem [0:7];

// Write Process
always @(posedge clk) begin
    if (wr_enb)
        mem[wr_ad] <= d_in;
end

// Read Process (Independent of wr_enb)
always @(posedge clk or negedge arstn) begin
    if (!arstn)
        d_out <= 8'd0;
    else
        d_out <= mem[rd_add];
end

endmodule
