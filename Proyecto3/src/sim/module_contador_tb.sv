`timescale 1ns/1ps

module module_contador_tb;

    // Parámetros del módulo
    localparam WAIT_TIME = 10;   // Reducido para simular rápido
    localparam WIDTH     = 4;

    // Señales
    logic clk;
    logic [WIDTH-1:0] sel;

    // Instancia del DUT
    module_contador #(
        .WAIT_TIME(WAIT_TIME),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .sel(sel)
    );

    // Generador de reloj
    initial clk = 0;
    always #5 clk = ~clk;   // periodo = 10 ns

    initial begin
        $display("======= TEST module_contador =======");

        // Esperar valores iniciales
        repeat (5) @(posedge clk);

        // Observar cambios de sel
        for (int i = 0; i < 20; i++) begin
            @(posedge clk);
            $display("t=%0t  sel=%b", $time, sel);
        end

        $display("======= FIN DEL TEST =======");
        $finish;
    end

endmodule