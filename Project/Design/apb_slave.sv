module apb_slave (
    input  wire        pclk,
    input  wire        presetn,
    input  wire [31:0] paddr,
    input  wire        pwrite,
    input  wire        psel,
    input  wire        penable,
    input  wire [31:0] pwdata,
    output reg  [31:0] prdata,
    output reg         pready,
    output wire        pslverr
);

    // Simple 256-word memory
    reg [31:0] mem [0:255];
    
    // Tie off error signal for this simple memory implementation
    assign pslverr = 1'b0; 

    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            prdata <= 32'h0;
            pready <= 1'b0;
        end else begin
            // Default ready state
            pready <= 1'b0;
            
            // ACCESS Phase: PSEL and PENABLE are high
            if (psel && penable) begin
                pready <= 1'b1; // Assert PREADY to complete transfer
                
                if (pwrite) begin
                    // Write Operation
                    mem[paddr[7:0]] <= pwdata;
                end else begin
                    // Read Operation
                    prdata <= mem[paddr[7:0]];
                end
            end
        end
    end
endmodule
