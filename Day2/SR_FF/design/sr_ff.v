module sr_flipflop(
    input s, r, clk, rst,
    output reg q, qbar
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0; qbar <= 1;
        end
        else begin
            case ({s, r})
                2'b00: begin q <= q;    qbar <= qbar; end
                2'b01: begin q <= 0;    qbar <= 1;    end
                2'b10: begin q <= 1;    qbar <= 0;    end
                2'b11: begin q <= 1'bx; qbar <= 1'bx; end
            endcase
        end
    end
endmodule

