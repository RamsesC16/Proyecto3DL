module module_cociente(
    input  logic       clk,
    input  logic       enable,
    input  logic       signo, 
    input  logic [1:0] indice,
    output logic [3:0] Q
);
    initial begin
        Q = 4'b0000;
    end
    always_ff @(posedge clk) begin
        if (enable) begin
            case (indice)
                2'b00: Q[3] <= ~signo;   // Si D>=0 → 1, si D<0 → 0
                2'b01: Q[2] <= ~signo;
                2'b10: Q[1] <= ~signo;
                2'b11: Q[0] <= ~signo;
            endcase
        end
    end
endmodule