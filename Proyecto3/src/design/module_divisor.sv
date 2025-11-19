module module_divisor(
    input  logic clk,
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic [3:0] Q,
    output logic [4:0] R,
    output logic [6:0] seg
);
    logic [4:0] R_next, D;
    logic signo;
    logic [1:0] indice;
    logic [4:0] R_reg;
    logic done;         // bandera de fin
    logic start;        // señal generada por "evaluar"

    // Instancias
    module_cambia_datos sh(
        .R_in(R_reg),
        .A(A),
        .indice(indice),
        .R_out(R_next)
    );

    module_resta rs(
        .R(R_next),
        .B(B),
        .D(D),
        .signo(signo)
    );

    module_cociente cq(
        .clk(clk),
        .enable(!done),   // deja de actualizar cuando done = 1
        .signo(signo),
        .indice(indice),
        .Q(Q)
    );

    module_evaluar eva(
        .B(B),
        .clk(clk),
        .start(start)
    );

    // Lógica secuencial
    always_ff @(posedge clk) begin
        if (start) begin
            R_reg <= 5'b00000; // <-- corregido a 5 bits
            indice <= 0;
            done <= 0;
        end else if (!done) begin // Actualización normal mientras no haya terminado
            if (!signo)
                R_reg <= D;       // R = D si D>=0
            else
                R_reg <= R_next;  // si D<0 

            // Avanza el índice y marca done si llegó a 3
            if (indice == 2'd3)
                done <= 1;
            else
                indice <= indice + 1'b1;
        end
    end

    assign R = R_reg;
endmodule