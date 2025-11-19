`timescale 1ns/1ps

module module_cociente_tb;

    // Señales del testbench
    logic clk;
    logic enable;
    logic signo;
    logic [1:0] indice;
    logic [3:0] Q;

    // Instancia del DUT
    module_cociente dut (
        .clk(clk),
        .enable(enable),
        .signo(signo),
        .indice(indice),
        .Q(Q)
    );

    // Generador de reloj (periodo = 10 ns)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("======== TEST module_cociente ========");

        // Valores iniciales
        enable = 0;
        signo  = 0;
        indice = 0;
        #10;

        // Activar enable e ir cambiando índice y signo
        enable = 1;

        // Caso 1: signo = 0 → se escribe 1 en la posición correspondiente
        for (int i = 0; i < 4; i++) begin
            indice = i;
            signo  = 0;      // ~signo = 1
            @(posedge clk);
            $display("signo=%0b indice=%0d -> Q=%b", signo, indice, Q);
        end

        // Caso 2: signo = 1 → se escribe 0 en la posición correspondiente
        for (int i = 0; i < 4; i++) begin
            indice = i;
            signo  = 1;      // ~signo = 0
            @(posedge clk);
            $display("signo=%0b indice=%0d -> Q=%b", signo, indice, Q);
        end

        // Desactivar enable y verificar que Q no cambia
        enable = 0;
        signo  = 0;
        indice = 2;
        @(posedge clk);
        $display("ENABLE=0 -> Q (sin cambios) = %b", Q);

        $display("======== FIN TEST ========");
        $finish;
    end

endmodule