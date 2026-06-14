`timescale 1ns/1ps

module tb_bcd_adder;

    logic [3:0] a, b;
    logic cin;
    logic [3:0] sum;
    logic cout;

    // Instantiate DUT
    bcd_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $display(" A    B   Cin  |  Sum  Cout ");
        $display("------------------------------");

        // Test cases
        a=4'd3; b=4'd4; cin=0; #10;
        $display("%d + %d + %d = %d  %b", a,b,cin,sum,cout);

        a=4'd5; b=4'd5; cin=0; #10;
        $display("%d + %d + %d = %d  %b", a,b,cin,sum,cout);

        a=4'd9; b=4'd1; cin=0; #10;
        $display("%d + %d + %d = %d  %b", a,b,cin,sum,cout);

        a=4'd8; b=4'd7; cin=0; #10;
        $display("%d + %d + %d = %d  %b", a,b,cin,sum,cout);

        a=4'd9; b=4'd9; cin=0; #10;
        $display("%d + %d + %d = %d  %b", a,b,cin,sum,cout);

        $finish;
    end

endmodule
