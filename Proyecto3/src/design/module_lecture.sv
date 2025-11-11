
`timescale 1ns/1ps

module module_lecture(
    input        clk,
    input        n_reset,
    input  [3:0] filas_raw,      // Filas directas del teclado (con rebote)
    output [3:0] columnas,
    output reg  [3:0] sample       // Código de la tecla presionada
);

    // --- Antirrebote para las 4 filas ---
    wire [3:0] filas_debounced; // Salida de los módulos antirrebote

    // Instanciamos un módulo DeBounce para cada una de las 4 filas.
    // El parámetro STABLE_CYCLES (ej. 50000 para ~1ms con clk de 50MHz)
    // determina cuánto tiempo debe estar estable la señal para ser válida.
    // Puedes ajustar este valor si el rebote persiste.
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : debounce_gen
            module_DeBounce #(.STABLE_CYCLES(50000)) u_debounce (
                .clk(clk),
                .rst_n(n_reset),
                .btn_async(filas_raw[i]),
                .btn_level(filas_debounced[i]),
                .btn_pulse() // No usamos el pulso aquí
            );
        end
    endgenerate

    // --- Lógica de Escaneo de Teclado ---
    reg [1:0]  col_index = 0;
    reg [16:0] scan_counter = 0; // Contador para cambiar de columna

    // El registro de columnas se rota para activar una columna a la vez.
    // El valor activo es '0'.
    reg [3:0] columnas_reg = 4'b1110; 
    assign columnas = columnas_reg;

    // Escaneo de columnas
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            scan_counter <= '0;
            col_index <= '0;
            columnas_reg <= 4'b1110;
        end else begin
            // Incrementamos el contador en cada ciclo.
            // Cuando llega a un umbral, cambiamos a la siguiente columna.
            // Esto ralentiza el escaneo para que los antirrebotes funcionen bien.
            // Un valor de 20000 da un buen margen.
            if (scan_counter < 20000) begin
                scan_counter <= scan_counter + 1;
            end else begin
                scan_counter <= '0;
                col_index <= (col_index == 3) ? 0 : col_index + 1;
                
                // Rotar el '0' en las columnas
                columnas_reg <= {columnas_reg[2:0], columnas_reg[3]};
            end
        end
    end

    // --- Detección de Tecla Presionada (Síncrona) ---
    // Este bloque se ha cambiado a always_ff (síncrono) para evitar
    // condiciones de carrera (race conditions) entre el cambio del
    // índice de columna (col_index) y el estado de las filas (filas_debounced).
    // Al registrar la salida, nos aseguramos de que la decodificación
    // sea estable y se elimine el "ghosting".
    always_ff @(posedge clk or negedge n_reset) begin
        if (!n_reset) begin
            sample <= 4'hF;
        end else begin
            // Por defecto, mantenemos el valor anterior si una tecla sigue presionada,
            // o lo limpiamos si no hay ninguna.
            if (filas_debounced == 4'b1111) begin
                sample <= 4'hF;
            end else begin
                // Decodificamos la tecla basándonos en la columna activa y la fila presionada.
                case (col_index)
                    2'd0: begin // Columna 0
                        case (filas_debounced)
                            4'b1110: sample <= 4'h1;
                            4'b1101: sample <= 4'h4;
                            4'b1011: sample <= 4'h7;
                            4'b0111: sample <= 4'hE;
                            default: sample <= 4'hF; // Evita latches en caso de múltiples pulsaciones
                        endcase
                    end
                    2'd1: begin // Columna 1
                        case (filas_debounced)
                            4'b1110: sample <= 4'h2;
                            4'b1101: sample <= 4'h5;
                            4'b1011: sample <= 4'h8;
                            4'b0111: sample <= 4'h0;
                            default: sample <= 4'hF;
                        endcase
                    end
                    2'd2: begin // Columna 2
                        case (filas_debounced)
                            4'b1110: sample <= 4'h3;
                            4'b1101: sample <= 4'h6;
                            4'b1011: sample <= 4'h9;
                            4'b0111: sample <= 4'hC;
                            default: sample <= 4'hF;
                        endcase
                    end
                    2'd3: begin // Columna 3
                        case (filas_debounced)
                            4'b1110: sample <= 4'hA;
                            4'b1101: sample <= 4'hB;
                            4'b1011: sample <= 4'hD;
                            4'b0111: sample <= 4'hF;
                            default: sample <= 4'hF;
                        endcase
                    end
                endcase
            end
        end
    end

endmodule
