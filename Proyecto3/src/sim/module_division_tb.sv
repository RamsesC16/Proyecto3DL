
`timescale 1ns/1ps

module module_division_tb;

    // Entradas del DUT
    logic        clk;
    logic        rst_n;
    logic        start;
    logic [7:0]  i_dividend;
    logic [7:0]  i_divisor;

    // Salidas del DUT
    logic [7:0]  o_quotient;
    logic [7:0]  o_remainder;
    logic        done;
    logic        error;

    // Instancia del DUT (Device Under Test)
    module_division dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .i_dividend(i_dividend),
        .i_divisor(i_divisor),
        .o_quotient(o_quotient),
        .o_remainder(o_remainder),
        .done(done),
        .error(error)
    );

    // Generador de reloj
    always #5 clk = ~clk;

    // Tarea para ejecutar una prueba de división
    task run_test(input [7:0] dividend, input [7:0] divisor, input [7:0] exp_quotient, input [7:0] exp_remainder, input exp_error);
        $display("Test: %d / %d", dividend, divisor);
        
        // Iniciar la operación
        i_dividend = dividend;
        i_divisor = divisor;
        start = 1;
        @(posedge clk);
        start = 0;

        // Esperar a que la señal 'done' se active
        wait (done);

        // Verificar resultados
        if (error == exp_error) begin
            if (!error) begin
                if (o_quotient == exp_quotient && o_remainder == exp_remainder) begin
                    $display("  -> PASSED. Q: %d, R: %d", o_quotient, o_remainder);
                end else begin
                    $error("  -> FAILED. Got Q: %d, R: %d. Expected Q: %d, R: %d", o_quotient, o_remainder, exp_quotient, exp_remainder);
                end
            end else begin
                $display("  -> PASSED. Error correctly detected.");
            end
        end else begin
            $error("  -> FAILED. Error status mismatch. Got: %b, Expected: %b", error, exp_error);
        end
        
        @(posedge clk); // Esperar un ciclo antes del siguiente test
    endtask

    // Secuencia de prueba principal
    initial begin
        $dumpfile("module_division_tb.vcd");
        $dumpvars(0, module_division_tb);
        $display("Starting module_division testbench...");

        // Inicialización
        clk = 0;
        rst_n = 0;
        start = 0;
        i_dividend = 0;
        i_divisor = 0;
        #20;
        rst_n = 1; // Liberar reset
        #10;

        // --- Casos de prueba ---
        run_test(100, 10, 10, 0, 0);  // 100 / 10 = 10, R = 0
        run_test(10, 3, 3, 1, 0);     // 10 / 3 = 3, R = 1
        run_test(255, 1, 255, 0, 0);  // 255 / 1 = 255, R = 0
        run_test(0, 5, 0, 0, 0);      // 0 / 5 = 0, R = 0
        run_test(123, 200, 0, 123, 0); // 123 / 200 = 0, R = 123
        run_test(255, 2, 127, 1, 0);  // 255 / 2 = 127, R = 1
        
        // Prueba de división por cero
        run_test(50, 0, 8'hFF, 8'hFF, 1); // 50 / 0 -> Error

        $display("All test cases finished.");
        $finish;
    end

endmodule
