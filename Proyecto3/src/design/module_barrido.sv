module module_barrido# (
    // Numero de ciclos entre pasos
    parameter int WAIT_TIME = 27000,
    // Numero de columnas
    parameter int WIDTH     = 4,
    // Activa active-low en la salida
    parameter bit ACTIVE_LOW = 1'b0
)(
    input  logic             apagar,
    input  logic             clk,
    output logic [WIDTH-1:0] col
);

    // Contador de ciclos de reloj
    int clockCounter = 0;

    // Registro de desplazamiento one-hot que indica qué columna está activa.
    logic [WIDTH-1:0] col_reg = { { (WIDTH-1){1'b0} }, 1'b1 };

    // Rota el bit activo cada vez que clockCounter alcance WAIT_TIME.
    always_ff @(posedge clk) begin
        // Girar a la izquierda: mover el bit más significativo al bit menos significativo.
        if (clockCounter >= WAIT_TIME) begin
            clockCounter <= 0;
            //Girar a la izquierda: mover el bit más significativo al bit menos significativo.
            col_reg <= { col_reg[WIDTH-2:0], col_reg[WIDTH-1] };
        end else begin
        clockCounter <= clockCounter + 1;
        end
    end

    logic [WIDTH-1:0] one_hot_out;

    // Cuando apagar=1: solo se utilizan los displays 1 y 2.
    // Cuando apagar=0: se utilizan todos los displays.
    assign one_hot_out = (apagar) ? {1'b0, col_reg[2], col_reg[1], 1'b0} : col_reg;

    // Aplica active-low si el parámetro ACTIVE_LOW está activado (es 1)
    assign col = ACTIVE_LOW ? ~one_hot_out : one_hot_out;
endmodule