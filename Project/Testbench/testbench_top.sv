`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"

module testbench;
    logic pclk;
    logic presetn;

    // Clock generation
    always #5 pclk = ~pclk;

    // Interface instantiation
    apb_if intf(pclk, presetn);

    // DUT instantiation
    apb_slave dut (
        .pclk(intf.pclk),
        .presetn(intf.presetn),
        .paddr(intf.paddr),
        .pwrite(intf.pwrite),
        .psel(intf.psel),
        .penable(intf.penable),
        .pwdata(intf.pwdata),
        .prdata(intf.prdata),
        .pready(intf.pready),
        .pslverr(intf.pslverr)
    );

    test t1;

    initial begin
        pclk = 0;
        presetn = 0;
        
        // Reset sequence
        #15 presetn = 1;
        
        t1 = new(intf);
        t1.run();
    end

    // Enable wave dumps for EDA Playground
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule
