module module_evaluar(
    input  logic clk,
    input  logic [3:0] B,
    output logic       start
);

    logic B_prev;

    always_ff @(posedge clk) begin
        B_prev <= (B != 0);                 // guardar si B era distinto de 0 antes
        start  <= (!B_prev && (B != 0));    // flanco de subida
    end

endmodule