module mod_out(
    input clk,
    input rst,
    input [7:0] din,
    output reg [2:0] out
);

reg [1:0] count;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        count <= 0;
        out <= 0;
    end
    else
    begin
        if(count == 2)
        begin
            count <= 0;

            // PROCESS EVERY 3rd INPUT
            if(din[2:0] == 3'b001)
                out <= 3'b001;
            else if(din[2:0] == 3'b010)
                out <= 3'b010;
            else if(din[2:0] == 3'b100)
                out <= 3'b100;
            else
                out <= 3'b000;   // ✅ IMPORTANT FIX
        end
        else
        begin
            count <= count + 1;
            out <= 3'b000;       // ✅ IMPORTANT FIX
        end
    end
end

endmodule
