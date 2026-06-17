class scoreboard;
    mailbox mon2scb;
    bit [31:0] ref_mem [256]; // Reference memory

    function new(mailbox mon2scb);
        this.mon2scb = mon2scb;
    endfunction

    task main();
        forever begin
            transaction trans;
            mon2scb.get(trans);

            if(trans.pwrite) begin
                ref_mem[trans.paddr] = trans.pwdata;
                $display("[Scoreboard] Wrote %0h to %0h", trans.pwdata, trans.paddr);
            end else begin
                if(ref_mem[trans.paddr] == trans.prdata)
                    $display("[Scoreboard] PASS: Read %0h from %0h", trans.prdata, trans.paddr);
                else
                    $error("[Scoreboard] FAIL: Addr: %0h Expected: %0h Actual: %0h", trans.paddr, ref_mem[trans.paddr], trans.prdata);
            end
        end
    endtask
endclass
