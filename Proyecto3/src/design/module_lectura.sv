module module_lectura #(
    parameter WIDTH = 4
)(
    input  logic              clk,
    output logic [WIDTH-1:0]  col,
    input  logic [WIDTH-1:0]  fil,
    output logic [3:0]        numero,
    input  logic              rst_in,
    output logic              reset,
    output logic              save,
    output logic              press_DB
);
    
    // barrido de columnas
    module_barrido #(.WIDTH(WIDTH)) barrido (
        .clk(clk),
        .col(col)
    );

    logic [WIDTH-1:0] fil_reg;
    logic [WIDTH-1:0] col_reg;

    module_register #(.WIDTH(WIDTH)) registro_filas (
        .clk(clk),
        .reset(1'b0),  // Reset fijo - no usar la salida reset del módulo
        .en(1'b1),
        .d(fil),
        .q(fil_reg)
    );
    
    module_register #(.WIDTH(WIDTH)) registro_columnas (
        .clk(clk),
        .reset(1'b0),  // Reset fijo - no usar la salida reset del módulo
        .en(1'b1),
        .d(col),
        .q(col_reg)
    );

    module_register #(.WIDTH(1)) registro_reset (
        .clk(clk),
        .reset(1'b0),
        .en(1'b1),
        .d(rst_in), // detectar si alguna columna está activa
        .q(reset_reg)
    );

    logic press_reg;

    assign press_reg = |fil_reg;

    // Inicialización de salidas constantes 
    assign save = 1'b0;
    
    // Variable interna para clear
    logic clear;
    
    module_DeBounce DB (
        .clk(clk),
        .n_reset(1'b1),
        .button_in(press_reg),
        .DB_out(press_DB)
    );

    module_DeBounce DB_rst (
        .clk(clk),
        .n_reset(1'b1),
        .button_in(reset_reg),
        .DB_out(reset)
    );

    logic [WIDTH-1:0]  col_pressed; // salida one-hot de la última columna aceptada
    logic [WIDTH-1:0]  fil_pressed; // salida one-hot de la última fila aceptada
    

    // Lógica de decodificación de números y clear
    always_ff @(posedge clk) begin
        if (reset) begin
            numero <= 4'b0000;
        end else begin // Solo actualizar cuando se confirme la pulsación
            case({col_reg, fil_reg})
                8'b0001_0001 : numero <= 4'b0001; // columna 0, fila 0 = 1
                8'b0010_0001 : numero <= 4'b0010; // columna 1, fila 0 = 2
                8'b0100_0001 : numero <= 4'b0011; // columna 2, fila 0 = 3
                8'b1000_0001 : numero <= 4'b1010; // columna 3, fila 0 = A

                8'b0001_0010 : numero <= 4'b0100; // columna 0, fila 1 = 4
                8'b0010_0010 : numero <= 4'b0101; // columna 1, fila 1 = 5
                8'b0100_0010 : numero <= 4'b0110; // columna 2, fila 1 = 6
                8'b1000_0010 : numero <= 4'b1011; // columna 3, fila 1 = B

                8'b0001_0100 : numero <= 4'b0111; // columna 0, fila 2 = 7
                8'b0010_0100 : numero <= 4'b1000; // columna 1, fila 2 = 8
                8'b0100_0100 : numero <= 4'b1001; // columna 2, fila 2 = 9
                8'b1000_0100 : numero <= 4'b1100; // columna 3, fila 2 = C

                8'b0001_1000 : numero <= 4'b1110; // columna 0, fila 3 = E
                8'b0010_1000 : numero <= 4'b0000; // columna 1, fila 3 = 0
                8'b0100_1000 : numero <= 4'b1111; // columna 2, fila 3 = F
                8'b1000_1000 : numero <= 4'b1101; // columna 3, fila 3 = D
                
                default      : begin
                    numero <= 4'b0000;
                end
            endcase
        end 
    end
    // Inicialización de valores por defecto
endmodule