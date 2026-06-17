class transaction;
    rand bit [31:0] paddr;
    rand bit [31:0] pwdata;
    rand bit        pwrite;
         bit [31:0] prdata;

    // Constrain addresses to our memory size
    constraint addr_c { paddr < 256; }
    
    function void display(string name);
        $display("[%s] Addr: %0h, Data: %0h, Write: %0b", name, paddr, (pwrite ? pwdata : prdata), pwrite);
    endfunction
endclass
