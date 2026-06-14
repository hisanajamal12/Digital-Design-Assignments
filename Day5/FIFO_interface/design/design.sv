`timescale 1ns/1ps

module fifo(fifo_if.DUT inf);

    // Memory & pointers (using logic instead of reg)
    logic [7:0] mem [7:0];
    logic [2:0] wr_ptr;
    logic [2:0] rd_ptr;
    integer i;

    // Status flags
    assign inf.full  = ((wr_ptr + 3'b001) == rd_ptr);
    assign inf.empty = (wr_ptr == rd_ptr);

    // Sequential logic
    always_ff @(posedge inf.clk)
    begin
        if(inf.rst)
        begin
            for(i = 0; i < 8; i++)
                mem[i] <= 8'b0;

            wr_ptr   <= 3'b000;
            rd_ptr   <= 3'b000;
            inf.data_out <= 8'b0;
        end
        else
        begin
            // WRITE
            if(inf.wrenb && !inf.full)
            begin
                mem[wr_ptr] <= inf.data_in;
                wr_ptr <= wr_ptr + 3'b001;
            end

            // READ
            if(inf.rdenb && !inf.empty)
            begin
                inf.data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 3'b001;
            end
        end
    end

endmodule
