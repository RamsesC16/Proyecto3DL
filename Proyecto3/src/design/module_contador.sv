module module_contador #(
    parameter WAIT_TIME = 27000,
    // Numero de columnas
    parameter WIDTH     = 4,
    // Establecer en 1 para que las columnas físicas sean activas en bajo (invertir la salida).
    parameter ACTIVE_LOW = 1'b0
)(
    input  logic             clk,
    output logic [WIDTH-1:0] sel
);

    // divisor de reloj/temporizador de pasos de funcionamiento libre simple
    logic [31:0] clockCounter = 0;

    // Registro de desplazamiento one-hot que indica qué columna está activa.
    logic [WIDTH-1:0] sel_reg = { WIDTH{1'b0} };

    assign sel = sel_reg;

    // Rota el bit activo cada vez que clockCounter alcance WAIT_TIME.
    always_ff @(posedge clk) begin
        // Girar a la izquierda: mover el bit más significativo al bit menos significativo.
        if (clockCounter >= WAIT_TIME) begin
            clockCounter <= 0;
            if (sel_reg == 2'b11) sel_reg <= 2'b00;
            else sel_reg <= sel_reg + 1;
        end else begin
            clockCounter <= clockCounter + 1;
        end
    end

endmodule