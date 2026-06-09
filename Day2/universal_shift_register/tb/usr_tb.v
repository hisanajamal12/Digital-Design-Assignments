module usr_tb;

reg clk, reset, sin;
reg [1:0] mode;
reg [3:0] pin;
wire sout;
wire [3:0] pout;

usr DUT(clk, reset, mode, sin, pin, sout, pout);

initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin

$monitor("mode=%b sin=%b pin=%b pout=%b sout=%b", mode, sin, pin, pout, sout);

reset = 1;
#10 reset = 0;

// PIPO (load parallel)
mode = 2'b11; pin = 4'b1011;
#10;

// SISO
mode = 2'b00; sin = 1;
#10;

// SIPO
mode = 2'b01; sin = 0;
#10;

// PISO
mode = 2'b10;
#10;

end

endmodule
