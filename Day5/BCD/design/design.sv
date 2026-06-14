//---------------- BCD ADDER ----------------//
module bcd_adder (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic cin,
    output logic [3:0] sum,
    output logic cout
);

    logic [3:0] s;
    logic c1;
    logic k;

    // First addition
    ripple_carry_adder rc1 (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(s),
        .cout(c1)
    );

    // BCD correction condition
    assign k = c1 | (s[3] & s[2]) | (s[3] & s[1]);

    // Second addition (add 6 if needed)
    ripple_carry_adder rc2 (
        .a(s),
        .b(k ? 4'b0110 : 4'b0000),
        .cin(1'b0),
        .sum(sum),
        .cout(cout)
    );

endmodule


//---------------- RIPPLE CARRY ADDER ----------------//
module ripple_carry_adder (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic cin,
    output logic [3:0] sum,
    output logic cout
);

    logic c1, c2, c3;

    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .carry(c1));
    full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c1),  .sum(sum[1]), .carry(c2));
    full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c2),  .sum(sum[2]), .carry(c3));
    full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c3),  .sum(sum[3]), .carry(cout));

endmodule


//---------------- FULL ADDER ----------------//
module full_adder (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic carry
);

    assign sum   = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (a & cin);

endmodule
