`timescale 1ns/1ps

module module_mux_41_tb;

    logic [1:0] sel;
    logic [15:0] in_data;
    logic [3:0] out_data;

    // DUT
    module_mux_41 dut (
        .sel(sel),
        .in_data(in_data),
        .out_data(out_data)
    );

    initial begin
        $display("=== Test corto module_mux_41 ===");

        // valores de prueba (4 grupos de 4 bits)
        in_data = 16'b1111_0101_0011_0001; 
        // grupos:
        // [3:0]   = 0001
        // [7:4]   = 0011
        // [11:8]  = 0101
        // [15:12] = 1111

        // prueba 1: sel = 00 -> out = in_data[3:0]
        sel = 2'b00; #10;

        // prueba 2: sel = 01 -> out = in_data[7:4]
        sel = 2'b01; #10;

        // prueba 3: sel = 10 -> out = in_data[11:8]
        sel = 2'b10; #10;

        // prueba 4: sel = 11 -> out = in_data[15:12]
        sel = 2'b11; #10;

        $display("sel final = %b | out_data final = %b", sel, out_data);

        $finish;
    end

endmodule