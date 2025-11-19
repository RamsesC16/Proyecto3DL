`timescale 1ns/1ps

module module_divisor_tb;

    // Señales
    logic clk;
    logic [3:0] A, B;
    logic [3:0] Q;
    logic [4:0] R;
    logic [6:0] seg;   // no se usa, pero conectamos

    // Instancia del DUT
    module_divisor dut (
        .clk(clk),
        .A(A),
        .B(B),
        .Q(Q),
        .R(R),
        .seg(seg)
    );

    // Generador de reloj (10 ns)
    initial clk = 0;
    always #5 clk = ~clk;

    // Tarea para ejecutar una división
    task run_division(input [3:0] a_in, input [3:0] b_in);
        logic [3:0] last_Q;
        int stable_cycles;

        begin
            A = a_in;
            B = b_in;

            $display("\n--- Ejecutando division: %0d / %0d ---", A, B);

            // Guardamos el primer Q
            last_Q = Q;
            stable_cycles = 0;

            // Esperar hasta que Q deje de cambiar = done
            repeat (30) begin
                @(posedge clk);

                if (Q == last_Q)
                    stable_cycles++;
                else
                    stable_cycles = 0;

                last_Q = Q;

                // Consideramos 3 ciclos estables como fin
                if (stable_cycles == 3)
                    break;
            end

            $display("Resultado final:  Q = %0d  (bin %b),  R = %0d  (bin %b)",
                     Q, Q, R, R);
        end
    endtask

    initial begin
        $display("======== INICIO TEST module_divisor ========");

        // Valores iniciales
        A = 0;
        B = 1;
        @(posedge clk);

        // Casos de prueba
        run_division(8, 2);   // 8 / 2 = 4, R=0
        run_division(9, 3);   // 9 / 3 = 3, R=0
        run_division(7, 2);   // 7 / 2 = 3, R=1
        run_division(14, 4);  // 14/4 = 3, R=2
        run_division(5, 5);   // 5/5 = 1, R=0
        run_division(3, 7);   // 3/7 = 0, R=3

        $display("\n======== FIN TEST ========");
        $finish;
    end

endmodule