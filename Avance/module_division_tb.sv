`timescale 1ns/1ps

module module_division_tb;

    logic i_dividend;
    logic i_divisor;
    logic o_quotient;
    logic o_error;

    module_division dut (
        .i_dividend(i_dividend),
        .i_divisor(i_divisor),
        .o_quotient(o_quotient),
        .o_error(o_error)
    );

    initial begin
        $dumpfile("module_division_tb.vcd");
        $dumpvars(0, module_division_tb);
        $display("Starting module_division test...");

        // Test case 1: 0 / 0 -> error
        i_dividend = 0; i_divisor = 0; #10;
        if (o_error == 1)
            $display("Test Case 1 (0/0): Passed");
        else
            $error("Test Case 1 (0/0): Failed");

        // Test case 2: 0 / 1 -> 0
        i_dividend = 0; i_divisor = 1; #10;
        if (o_quotient == 0 && o_error == 0)
            $display("Test Case 2 (0/1): Passed");
        else
            $error("Test Case 2 (0/1): Failed");

        // Test case 3: 1 / 0 -> error
        i_dividend = 1; i_divisor = 0; #10;
        if (o_error == 1)
            $display("Test Case 3 (1/0): Passed");
        else
            $error("Test Case 3 (1/0): Failed");

        // Test case 4: 1 / 1 -> 1
        i_dividend = 1; i_divisor = 1; #10;
        if (o_quotient == 1 && o_error == 0)
            $display("Test Case 4 (1/1): Passed");
        else
            $error("Test Case 4 (1/1): Failed");

        $display("All test cases finished.");
        $finish;
    end

endmodule