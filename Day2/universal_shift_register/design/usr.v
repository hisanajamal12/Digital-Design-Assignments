module usr(clk, reset, mode, sin, pin, sout, pout);

input clk, reset, sin;
input [1:0] mode;
input [3:0] pin;

output reg sout;
output reg [3:0] pout;

always @(posedge clk)
begin
    if(reset)
    begin
        pout <= 4'b0000;
        sout <= 0;
    end

    else
    begin
        case(mode)

        2'b00: // SISO
        begin
            sout <= pout[0];
            pout <= {sin, pout[3:1]};
        end

        2'b01: // SIPO
        begin
            pout <= {sin, pout[3:1]};
        end

        2'b10: // PISO
        begin
            sout <= pout[0];
            pout <= {1'b0, pout[3:1]};
        end

        2'b11: // PIPO
        begin
            pout <= pin;
        end

        endcase
    end
end

endmodule
