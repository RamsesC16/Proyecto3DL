`timescale 1ns/1ps

module module_register_tb;

    logic clk;
    logic reset;
    logic en;
    logic [3:0] d;
    logic [3:0] q;

    module_register #(.WIDTH(4)) dut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .d(d),
        .q(q)
    );

    // reloj simple
    initial begin 
        clk = 0; 
        forever #5 clk = ~clk; 
    end

    initial begin
        $display("=== Test corto module_register ===");

        // reset
        reset = 1; en = 0; d = 4'hA; #10;
        reset = 0;

        // cargar un valor
        en = 1; d = 4'h5; #10;

        // cambiar d pero con enable apagado
        en = 0; d = 4'hF; #10;

        // habilitar y cargar nuevo valor
        en = 1; d = 4'h3; #10;

        $display("q final = %b", q);
        $finish;
    end

endmodule