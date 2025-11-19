`timescale 1ns/1ps

module module_top_tb;

    logic clk;
    logic [3:0] fil;
    logic rst_in;
    logic rst_1;
    logic [3:0] col;
    logic [6:0] seg;
    logic seg_dot;
    logic [3:0] cats;

    module_top dut(
        .clk(clk),
        .fil(fil),
        .rst_in(rst_in),
        .rst_1(rst_1),
        .col(col),
        .seg(seg),
        .seg_dot(seg_dot),
        .cats(cats)
    );

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // procedimiento de usuario
    initial begin
        $display("=== Test estilo usuario module_top ===");

        // reset global
        rst_in = 1;
        fil = 4'b0000;
        #50;
        rst_in = 0;

        // ==========================
        // Simular presionar tecla 3
        // ==========================
        // El modulo de lectura activa una columna a la vez.
        // Aqui forzamos fil para indicar "fila seleccionada".
        // El valor exacto depende de como tengas el keypad.
        // Usamos un pulso corto para simular la tecla.

        $display("[USUARIO] Presiona tecla 3");
        fil = 4'b0001;  // fila donde esta el 3
        #40;
        fil = 4'b0000;  // suelta la tecla
        #200;

        // ==========================
        // Simular presionar tecla 7
        // ==========================
        $display("[USUARIO] Presiona tecla 7");
        fil = 4'b0100;  // fila donde esta el 7
        #40;
        fil = 4'b0000;
        #200;

        // dejar tiempo para que el divisor procese
        #5000;

        // ==========================
        // Mostrar estados del display
        // ==========================
        $display("seg = %b", seg);
        $display("cats = %b", cats);
        $display("col = %b", col);

        $display("=== Fin test estilo usuario ===");
        $finish;
    end

endmodule