class fifo_transaction;

    // stimulus signals
    rand bit [7:0] data_in;
    rand bit wrenb;
    rand bit rdenb;

    // observed outputs
    bit [2:0] out;

    // optional status tracking
    bit full;
    bit empty;

    // display method (for debugging)
    function void display();
        $display("DATA=%0h WR=%0b RD=%0b OUT=%0b FULL=%0b EMPTY=%0b",
                  data_in, wrenb, rdenb, out, full, empty);
    endfunction

endclass
