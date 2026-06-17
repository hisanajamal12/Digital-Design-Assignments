class monitor;
    virtual apb_if vif;
    mailbox mon2scb;

    function new(virtual apb_if vif, mailbox mon2scb);
        this.vif = vif;
        this.mon2scb = mon2scb;
    endfunction

    task main();
        forever begin
            transaction trans;
            trans = new();
            
            // Sample exactly when a transfer completes
            @(posedge vif.pclk);
            if(vif.psel && vif.penable && vif.pready) begin
                trans.paddr  = vif.paddr;
                trans.pwrite = vif.pwrite;
                if(vif.pwrite) trans.pwdata = vif.pwdata;
                else           trans.prdata = vif.prdata;
                
                mon2scb.put(trans);
            end
        end
    endtask
endclass#
