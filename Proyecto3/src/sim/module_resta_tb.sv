`timescale 1ns/1ps

module module_resta_tb;

    logic [4:0] R;
    logic [3:0] B;
    logic [4:0] D;
    logic signo;

    // DUT
    module_resta dut (
        .R(R),
        .B(B),
        .D(D),
        .signo(signo)
    );

    initial begin
        $display("=== Test module_resta ===");

        // Caso 1: R > B (positivo)
        R = 5'd12; B = 4'd5; #1;
        $display("R=%d  B=%d  D=%d  signo=%b", R, B, D, signo);

        // Caso 2: R = B
        R = 5'd9; B = 4'd9; #1;
        $display("R=%d  B=%d  D=%d  signo=%b", R, B, D, signo);

        // Caso 3: R < B (negativo)
        R = 5'd7; B = 4'd12; #1;
        $display("R=%d  B=%d  D=%d  signo=%b", R, B, D, signo);

        $finish;
    end

endmodule