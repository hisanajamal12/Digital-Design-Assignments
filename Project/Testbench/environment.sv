class environment();
    generator  gen;
    driver     driv;
    monitor    mon;
    scoreboard scb;
    
    mailbox gen2driv;
    mailbox mon2scb;
    virtual apb_if vif;

    function new(virtual apb_if vif);
        this.vif = vif;
        gen2driv = new();
        mon2scb  = new();
        gen  = new(gen2driv);
        driv = new(vif, gen2driv);
        mon  = new(vif, mon2scb);
        scb  = new(mon2scb);
    endfunction

    task pre_test();
        vif.psel <= 0;
        vif.penable <= 0;
    endtask

    task test();
        fork
            gen.main();
            driv.main();
            mon.main();
            scb.main();
        join_any
    endtask

    task run();
        pre_test();
        test();
        #100; // Let final transactions flush
        $finish;
    endtask
endclass 
