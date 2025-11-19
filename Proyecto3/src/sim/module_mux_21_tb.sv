`timescale 1ns/1ps

module module_mux_21_tb;

    logic sel;
    logic [3:0] in_1;
    logic [3:0] in_2;
    logic [3:0] out_data;

    // DUT
    module_mux_21 dut (
        .sel(sel),
        .in_1(in_1),
        .in_2(in_2),
        .out_data(out_data)
    );

    initial begin
        $display("=== Test corto module_mux_21 ===");

        // valores iniciales
        in_1 = 4'b0101;
        in_2 = 4'b1110;

        // prueba 1: sel = 0 -> out = in_1
        sel = 1'b0;
        #10;

        // prueba 2: sel = 1 -> out = in_2
        sel = 1'b1;
        #10;

        // mostrar resultados finales
        $display("in_1 = %b", in_1);
        $display("in_2 = %b", in_2);
        $display("sel final = %b", sel);
        $display("out_data final = %b", out_data);

        $finish;
    end

endmodule