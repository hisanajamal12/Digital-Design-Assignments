`timescale 1ns/1ps

module tb;

    // Clock
    logic clk = 0;
    always #5 clk = ~clk;

    // Interface
    fifo_if vif(clk);

    // Transaction handle
    fifo_txn tx;

    // DUT
    top_module dut (
        .clk(clk),
        .rst(vif.rst),
        .data_in(vif.data_in),
        .wrenb(vif.wrenb),
        .rdenb(vif.rdenb),
        .out(vif.out)
    );

    // ---------------- RESET TASK ----------------
    task reset_dut();
        vif.rst = 1;
        vif.wrenb = 0;
        vif.rdenb = 0;
        vif.data_in = 0;
        repeat(2) @(posedge clk);
        vif.rst = 0;
    endtask

    // ---------------- WRITE TASK ----------------
    task write_data(input [7:0] data);
        @(posedge clk);
        vif.wrenb  = 1;
        vif.rdenb  = 0;
        vif.data_in = data;
    endtask

    // ---------------- READ TASK ----------------
    task read_data();
        @(posedge clk);
        vif.wrenb  = 0;
        vif.rdenb  = 1;
    endtask

    // ---------------- MAIN TEST ----------------
    initial begin

        tx = new();

        // Reset
        reset_dut();

        // WRITE TRANSACTIONS
        repeat (5) begin
            tx.randomize();
            write_data(tx.data_in);
            tx.print_txn();
        end

        // Stop writing
        @(posedge clk);
        vif.wrenb = 0;

        // READ TRANSACTIONS
        repeat (5) begin
            read_data();
            @(posedge clk);
            tx.out = vif.out;
            tx.print_txn();
        end

        #20;
        $finish;

    end

endmodule
