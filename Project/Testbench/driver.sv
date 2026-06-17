class driver;
    virtual apb_if vif;
    mailbox gen2driv;

    function new(virtual apb_if vif, mailbox gen2driv);
        this.vif = vif;
        this.gen2driv = gen2driv;
    endfunction

    task main();
        forever begin
            transaction trans;
            gen2driv.get(trans);

            @(posedge vif.pclk);
            // SETUP PHASE
            vif.psel   <= 1;
            vif.penable<= 0;
            vif.paddr  <= trans.paddr;
            vif.pwrite <= trans.pwrite;
            if(trans.pwrite) vif.pwdata <= trans.pwdata;

            @(posedge vif.pclk);
            // ACCESS PHASE
            vif.penable <= 1;

            // Wait for PREADY
            wait(vif.pready);
            
            @(posedge vif.pclk);
            // Return to IDLE
            vif.psel    <= 0;
            vif.penable <= 0;
        end
    endtask
endclass
