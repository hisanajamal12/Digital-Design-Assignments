module encoder_tb();

    reg [3:0] D;
    wire [1:0] b;
    integer m;

   
    encoder4_2 dut(.D(D), .b(b));

   initial
    begin
        D = 0;
      
        for(m = 0; m < 4; m = m + 1) 
        begin 
            #10;
            
        end
        #10 $finish;
    end

endmodule

