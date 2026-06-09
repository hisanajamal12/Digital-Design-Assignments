rca_4bit_tb;
module rca_4bit_tb;

reg A0, A1, A2, A3;
reg B0, B1, B2, B3;
reg Cin;

wire S0, S1, S2, S3;
wire Cout;

rca_4bit DUT (A0, A1, A2, A3, B0, B1, B2, B3, Cin, S0, S1, S2, S3, Cout);

initial
begin

A0=0; A1=0; A2=0; A3=0;
B0=0; B1=0; B2=0; B3=0;
Cin=0;
#10;

A0=1; A1=1; A2=0; A3=0;
B0=1; B1=0; B2=1; B3=0;
Cin=0;
#10;

A0=1; A1=1; A2=1; A3=1;
B0=1; B1=0; B2=0; B3=0;
Cin=1;
#10;

$monitor("A=%b%b%b%b B=%b%b%b%b Cin=%b -> S=%b%b%b%b Cout=%b",
          A3,A2,A1,A0, B3,B2,B1,B0, Cin, S3,S2,S1,S0, Cout);

end

endmodule
