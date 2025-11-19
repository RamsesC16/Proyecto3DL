`timescale 1ns/1ps

module module_lectura_tb;

    localparam WIDTH = 4;

    logic clk;
    logic [WIDTH-1:0] col;
    logic [WIDTH-1:0] fil;
    logic [3:0] numero;
    logic rst_in;
    logic reset;
    logic save;
    logic press_DB;

    // DUT
    module_lectura #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .col(col),
        .fil(fil),
        .numero(numero),
        .rst_in(rst_in),
        .reset(reset),
        .save(save),
        .press_DB(press_DB)
    );

    // clock 10ns
    initial clk = 0;
    always #5 clk = ~clk;

    // estímulos simples
    initial begin
        $display("=== Test corto de module_lectura ===");

        fil   = 4'b0000;
        rst_in = 1'b0;

        // Esperar unas vueltas de barrido
        repeat (20) @(posedge clk);

        // Simular pulsacion: fila 0 activa
        fil = 4'b0001;

        // solo durante un pequeño tiempo
        repeat (40) @(posedge clk);

        fil = 4'b0000;

        // mostrar resultado al final
        $display("Numero detectado: %b", numero);

        $finish;
    end

endmodule