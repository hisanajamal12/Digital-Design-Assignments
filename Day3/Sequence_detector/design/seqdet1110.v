module sequencedetect(input clk, rst, din, output reg detected);

parameter idle = 2'b00;
parameter s1   = 2'b01;
parameter s2   = 2'b10;
parameter s3   = 2'b11;

reg [1:0] ps, ns;

// present state
always @(posedge clk or posedge rst)
begin
    if(rst)
        ps <= idle;
    else
        ps <= ns;
end

// next state + output logic
always @(*)
begin
    ns = idle;
    detected = 0;

    case(ps)

    idle:
        if(din) ns = s1;
        else     ns = idle;

    s1: // 1
        if(din) ns = s2;
        else     ns = idle;

    s2: // 11
        if(din) ns = s3;
        else     ns = idle;

    s3: // 111
        if(din)
            ns = s3;   // overlap (still 111)
        else
        begin
            ns = idle;
            detected = 1; // 1110 detected
        end

    endcase
end

endmodule
