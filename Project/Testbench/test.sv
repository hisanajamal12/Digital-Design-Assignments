class test;
    environment env;

    function new(virtual apb_if vif);
        env = new(vif);
    endfunction

    task run();
        env.gen.repeat_count = 10; // Generate 10 transactions
        env.run();
    endtask
endclass
