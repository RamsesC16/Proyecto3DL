`timescale 1ns/1ps

module module_fsm_tb;

    logic clk;
    logic reset;
    logic press;
    logic [1:0] y_AB;
    logic y_disp;
    logic reset_2;

    // DUT
    module_fsm dut (
        .clk(clk),
        .reset(reset),
        .press(press),
        .y_AB(y_AB),
        .y_disp(y_disp),
        .reset_2(reset_2)
    );

    // Clock: 10 ns period
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Stimulus
    initial begin
        $display("-----------------------------------------------");
        $display(" FSM TESTBENCH                                ");
        $display("-----------------------------------------------");
        $display(" time | press reset | state outputs");
        $display("-----------------------------------------------");

        // initial
        reset = 1;
        press = 0;
        #20;

        reset = 0;

        // sequence of presses to move through states
        repeat (2) @(posedge clk);

        // INICIO -> PRIMERO
        press = 1; @(posedge clk);
        press = 0; @(posedge clk);

        // PRIMERO -> SEGUNDO
        press = 1; @(posedge clk);
        press = 0; @(posedge clk);

        // SEGUNDO -> DIVIDIR
        press = 1; @(posedge clk);
        press = 0; @(posedge clk);

        // DIVIDIR -> RESET
        press = 1; @(posedge clk);
        press = 0; @(posedge clk);

        // RESET -> INICIO (automatic)
        @(posedge clk);

        $display("-----------------------------------------------");
        $finish;
    end

    // Monitor formatted
    always @(posedge clk) begin
        $display(" %4dns |   %b     %b   | y_AB=%b y_disp=%b reset_2=%b",
            $time, press, reset, y_AB, y_disp, reset_2);
    end

endmodule