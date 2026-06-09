module rca_4bit(
    input A0, A1, A2, A3,
    input B0, B1, B2, B3,
    input Cin,
    output S0, S1, S2, S3,
    output Cout
);

wire C1, C2, C3;

fulladd FA1 (A0, B0, Cin, S0, C1);
fulladd FA2 (A1, B1, C1, S1, C2);
fulladd FA3 (A2, B2, C2, S2, C3);
fulladd FA4 (A3, B3, C3, S3, Cout);

endmodule
