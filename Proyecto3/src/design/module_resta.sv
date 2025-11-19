module module_resta(
    input  logic [4:0] R,      // resto parcial extendido (1 bit extra)
    input  logic [3:0] B,
    output logic [4:0] D,      // diferencia
    output logic       signo   // 1 si D<0
);
    always_comb begin
        D = R - {1'b0, B};     // R - B 
    end
    assign signo = D[4];       // bit más significativo indica signo

endmodule