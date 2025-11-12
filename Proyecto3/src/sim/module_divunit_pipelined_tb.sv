`timescale 1ns/1ps

module module_divunit_pipelined_blocks_tb;

    parameter N = 16;

    // Señales
    logic clk, rst;
    logic start, valid;
    logic signed [N-1:0] A_in, B_in;
    logic signed [N-1:0] Q_out, R_out;
    logic done, error_div0;

    // Instancia del divisor pipelined por bloques
    div_unit_pipelined_blocks #(.N(N), .STAGES(4)) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .valid(valid),
        .A_in(A_in),
        .B_in(B_in),
        .Q_out(Q_out),
        .R_out(R_out),
        .done(done),
        .error_div0(error_div0)
    );

    // Generador de reloj
    initial clk = 0;
    always #10 clk = ~clk; // periodo = 20 ns -> 50 MHz

    // Estímulos
    initial begin
        $display("=== Inicio de simulacion (pipelined bloques) ===");
        rst = 1; start = 0; valid = 0;
        A_in = 0; B_in = 0;
        #50 rst = 0;

        // Caso 1: 100 / 5 = 20
        @(posedge clk);
        A_in = 100; B_in = 5;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 1: 100/5 -> Q=%0d, R=%0d, error=%b", Q_out, R_out, error_div0);

        // Caso 2: -75 / 5 = -15
        @(posedge clk);
        A_in = -75; B_in = 5;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 2: -75/5 -> Q=%0d, R=%0d, error=%b", Q_out, R_out, error_div0);

        // Caso 3: 50 / -10 = -5
        @(posedge clk);
        A_in = 50; B_in = -10;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 3: 50/-10 -> Q=%0d, R=%0d, error=%b", Q_out, R_out, error_div0);

        // Caso 4: Division por cero
        @(posedge clk);
        A_in = 25; B_in = 0;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 4: 25/0 -> Q=%0d, R=%0d, error=%b", Q_out, R_out, error_div0);

        // Caso 5: 22 / 5 -> Q=4, R=2
        @(posedge clk);
        A_in = 22; B_in = 5;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 5: 22/5 -> Q=%0d, R=%0d", Q_out, R_out);

        // Caso 6: 19 / 4 -> Q=4, R=3
        @(posedge clk);
        A_in = 19; B_in = 4;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 6: 19/4 -> Q=%0d, R=%0d", Q_out, R_out);

        // Caso 7: 32767 / 2 -> Q=16383, R=1
        @(posedge clk);
        A_in = 32767; B_in = 2;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 7: 32767/2 -> Q=%0d, R=%0d", Q_out, R_out);

        // Caso 8: -32768 / 2 -> Q=-16384, R=0
        @(posedge clk);
        A_in = -32768; B_in = 2;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 8: -32768/2 -> Q=%0d, R=%0d", Q_out, R_out);

        // Caso 9: 5 / 10 -> Q=0, R=5
        @(posedge clk);
        A_in = 5; B_in = 10;
        start = 1; valid = 1;
        @(posedge clk); start = 0; valid = 0;
        wait(done);
        $display("Caso 9: 5/10 -> Q=%0d, R=%0d", Q_out, R_out);

        $display("=== Fin de simulacion (pipelined bloques) ===");
        $finish;
    end

endmodule