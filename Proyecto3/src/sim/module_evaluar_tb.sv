`timescale 1ns/1ps

module module_evaluar_tb;

    logic clk;
    logic [3:0] B;
    logic start;

    // DUT
    module_evaluar dut (
        .clk(clk),
        .B(B),
        .start(start)
    );

    // reloj: periodo 10 ns
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        $display("TB start");
        B = 4'b0000;

        // esperar unos ciclos
        #20;

        // Caso: B pasa de 0 a no-0 -> debe activar start por 1 ciclo
        B = 4'b0101;
        #20;

        // mantener B no-0 -> start NO debe volver a activarse
        B = 4'b0110;
        #20;

        // volver a 0
        B = 4'b0000;
        #20;

        // pasar a no-0 de nuevo -> debe activar start otra vez
        B = 4'b1111;
        #20;

        $finish;
    end

    initial begin
        $monitor("t=%0dns  B=%b  start=%b", $time, B, start);
    end

endmodule