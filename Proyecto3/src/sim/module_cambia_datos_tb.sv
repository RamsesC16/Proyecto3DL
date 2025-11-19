`timescale 1ns/1ps

module module_cambia_datos_tb;

    // Señales del testbench
    logic [4:0] R_in;
    logic [3:0] A;
    logic [1:0] indice;
    logic [4:0] R_out;

    // Instancia del DUT
    module_cambia_datos dut (
        .R_in(R_in),
        .A(A),
        .indice(indice),
        .R_out(R_out)
    );

    initial begin
        $display("===== TEST module_cambia_datos =====");

        // Caso base
        R_in  = 5'b00000;
        A     = 4'b1011;   // A[3]=1, A[2]=0, A[1]=1, A[0]=1
        indice = 0;        // Toma A[3]
        #1;
        $display("R_in=%b A=%b indice=%0d  -> R_out=%b", R_in, A, indice, R_out);

        // Variar índice
        for (int i = 0; i < 4; i++) begin
            R_in  = 5'b00101;  // 5 en binario
            A     = 4'b1100;
            indice = i[1:0];
            #1;
            $display("R_in=%b A=%b indice=%0d -> R_out=%b", R_in, A, indice, R_out);
        end

        // Sweep completo para verificar todos los casos
        $display("---- Sweep completo ----");
        for (int r = 0; r < 8; r++) begin
            for (int i = 0; i < 4; i++) begin
                R_in  = r;
                A     = 4'b0110;
                indice = i;
                #1;
                $display("R_in=%05b A=%b indice=%0d -> R_out=%05b",
                         R_in, A, indice, R_out);
            end
        end

        $display("===== FIN TEST =====");
        $finish;
    end

endmodule