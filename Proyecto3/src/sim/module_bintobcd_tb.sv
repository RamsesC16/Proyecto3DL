`timescale 1ns/1ps

module module_bintobcd_tb;

    // Parámetros del DUT
    localparam WIDTH_IN  = 4;
    localparam WIDTH_OUT = 8;

    // Señales del testbench
    logic [WIDTH_IN-1:0]  bin_1;
    logic [WIDTH_IN-1:0]  bin_2;
    logic [WIDTH_OUT-1:0] bcd_1;
    logic [WIDTH_OUT-1:0] bcd_2;

    // Instancia del módulo
    module_bintobcd #(
        .WIDTH_IN(WIDTH_IN),
        .WIDTH_OUT(WIDTH_OUT)
    ) dut (
        .bin_1(bin_1),
        .bin_2(bin_2),
        .bcd_1(bcd_1),
        .bcd_2(bcd_2)
    );

    // Procedimiento de prueba
    initial begin
        $display("==== TEST BINARY TO BCD ====");

        // Caso 1: valores pequeños
        bin_1 = 4'd3; 
        bin_2 = 4'd7;
        #1;
        $display("bin_1=%0d -> bcd_1=%02d | bin_2=%0d -> bcd_2=%02d", 
                  bin_1, bcd_1, bin_2, bcd_2);

        // Caso 2: valores cercanos a 9
        bin_1 = 4'd8;
        bin_2 = 4'd9;
        #1;
        $display("bin_1=%0d -> bcd_1=%02d | bin_2=%0d -> bcd_2=%02d", 
                  bin_1, bcd_1, bin_2, bcd_2);

        // Caso 3: sweeping de todas las combinaciones
        $display("---- Sweep completo ----");
        for (int a = 0; a < 10; a++) begin
            for (int b = 0; b < 10; b++) begin
                bin_1 = a;
                bin_2 = b;
                #1;
                $display("A=%0d BCD_A=%02d | B=%0d BCD_B=%02d",
                         bin_1, bcd_1, bin_2, bcd_2);
            end
        end

        $display("==== FIN DEL TEST ====");
        $finish;
    end

endmodule