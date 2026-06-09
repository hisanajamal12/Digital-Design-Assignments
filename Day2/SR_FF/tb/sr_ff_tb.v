module sr_ff_tb();
    reg s, r, clk, rst;
    wire q, qbar;
    
    sr_flipflop dut(s, r, clk, rst, q, qbar);
    
    // ???????? ??????
    always #5 clk = ~clk; 
    
    initial begin
        clk = 0; rst = 1; #10;
        rst = 0;
        s = 0; r = 1; #10;
        s = 1; r = 0; #10;
        $finish;
    end
endmodule

