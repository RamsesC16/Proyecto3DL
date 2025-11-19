module module_cambia_datos(
    input  logic [4:0] R_in,
    input  logic [3:0] A,
    input  logic [1:0] indice,  
    output logic [4:0] R_out
);
    // Desplaza R y agrega el bit correspondiente de A
    always_comb begin
        R_out = (R_in << 1) | A[3 - indice];
    end
endmodule