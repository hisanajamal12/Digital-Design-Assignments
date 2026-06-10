module fifo_(
    input clk, rst, wrenb, rdenb,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full, empty
);

reg [7:0] mem [7:0];
reg [2:0] wr_ptr;
reg [2:0] rd_ptr;
integer i;

always @(posedge clk)
begin
    if(rst)
    begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        data_out <= 0;

        for(i=0; i<8; i=i+1)
            mem[i] <= 0;
    end
    else
    begin
        // WRITE
        if(wrenb && !full)
        begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end

        // READ
        if(rdenb && !empty)
        begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end
end

// STATUS FLAGS
always @(*)
begin
    full  = ((wr_ptr + 1) == rd_ptr);
    empty = (wr_ptr == rd_ptr);
end

endmodule
