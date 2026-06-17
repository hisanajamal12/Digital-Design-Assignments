class generator;
    transaction trans;
    mailbox gen2driv;
    int repeat_count;

    function new(mailbox gen2driv);
        this.gen2driv = gen2driv;
    endfunction

    task main();
        for(int i = 0; i < repeat_count; i++) begin
            trans = new();
            if(!trans.randomize()) $fatal("Gen:: transaction randomization failed");
            gen2driv.put(trans);
        end
    endtask
endclass
