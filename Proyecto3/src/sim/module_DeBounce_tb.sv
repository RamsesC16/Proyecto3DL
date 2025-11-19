`timescale 1ns/1ps

module module_DeBounce_tb;

    // Parámetros reducidos para simulación
    localparam N = 10;  

    // Señales
    logic clk;
    logic n_reset;
    logic button_in;
    logic DB_out;

    // Instancia del DUT
    module_DeBounce #(
        .N(N)
    ) dut (
        .clk(clk),
        .n_reset(n_reset),
        .button_in(button_in),
        .DB_out(DB_out)
    );

    // Generador de reloj (10 ns por ciclo)
    initial clk = 0;
    always #5 clk = ~clk;

    // Tarea para simular rebotes típicos
    task bounce(input integer times, input integer high_time, input integer low_time);
        begin
            repeat(times) begin
                button_in = 1;
                #(high_time);
                button_in = 0;
                #(low_time);
            end
        end
    endtask

    initial begin
        $display("======== INICIO TEST module_DeBounce ========");

        // Estado inicial
        n_reset    = 0;
        button_in  = 0;
        #30;
        n_reset = 1;

        // ------------------------------------------------------------
        // 1) Rebotes cortos → NO debe activar pulso
        // ------------------------------------------------------------
        $display("\n--- Caso 1: Rebote corto, NO debe activarse DB_out ---");
        bounce(5, 3, 3);   // rebote rápido
        #100;

        // ------------------------------------------------------------
        // 2) Mantener presionado lo suficiente → pulso DB_out debe salir
        // ------------------------------------------------------------
        $display("\n--- Caso 2: Presion real, SI debe activarse DB_out ---");
        button_in = 1;
        #(500);   // suficiente para que q_reg[N-1] se ponga en 1
        #50;
        button_in = 0;

        #200;

        // ------------------------------------------------------------
        // 3) Rebote al soltar → NO debe generar segundo pulso
        // ------------------------------------------------------------
        $display("\n--- Caso 3: Rebote al soltar, NO debe generar segundo pulso ---");
        bounce(4, 4, 4);
        #200;

        // ------------------------------------------------------------
        // 4) Segundo pulso válido luego del tiempo inhibido
        // ------------------------------------------------------------
        $display("\n--- Caso 4: Segundo pulso valido tras inhibicion ---");
        // Simular tiempo estable en bajo
        button_in = 0;
        #(800);     // suficiente para que inhibit_reg[N_INHIBIT-1] = 1

        // Nueva presión válida
        button_in = 1;
        #(500);

        #200;

        $display("\n======== FIN TEST ========");
        $finish;
    end

endmodule