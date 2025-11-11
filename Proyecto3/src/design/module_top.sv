`timescale 1ns/1ps

module module_top(
    input  wire        clk,
    output wire [3:0]  columnas,
    input  wire [3:0]  filas_raw,
    output wire [3:0]  a,
    output wire [6:0]  d
);

    // --- Señales Internas ---
    wire [3:0]  key_sample;
    wire [3:0]  key_code;
    wire        key_pulse;
    wire        rst_n;

    // Lógica de la calculadora
    enum {S_IDLE, S_OPERAND_1, S_OPERAND_2, S_CALC, S_RESULT} state;
    reg [7:0]   operand_1;
    reg [7:0]   operand_2;
    reg [15:0]  display_reg; // Registro para mostrar números
    reg         div_start;
    wire [7:0]  div_quotient;
    wire [7:0]  div_remainder;
    wire        div_done;
    wire        div_error;

    // Salidas a periféricos
    wire [15:0] bcd_out;
    wire [6:0]  segments;
    wire [3:0]  anodos;

    // --- Reset Interno ---
    // Genera una señal de reset activa-baja (rst_n) al inicio.
    // rst_n se mantiene en 0 hasta que el contador llega a 255, luego se queda en 1.
    reg [7:0] reset_counter = 0;
    assign rst_n = (reset_counter == 8'hFF);
    always @(posedge clk) begin
        if (!rst_n) reset_counter <= reset_counter + 1;
    end

    // --- Módulo de Lectura de Teclado ---
    module_lecture u_lecture (
        .clk(clk),
        .n_reset(rst_n),
        .filas_raw(filas_raw),
        .columnas(columnas),
        .sample(key_sample) // Salida ya estabilizada
    );

    // --- Detección de Pulso de Tecla (Flanco de Subida) ---
    reg [3:0] key_sample_dly = 4'hF; // Registro para detectar el flanco
    // Un pulso se genera cuando la tecla actual es válida (no F) y la anterior era F (no presionada)
    assign key_pulse = (key_sample != 4'hF) && (key_sample_dly == 4'hF);
    always @(posedge clk) key_sample_dly <= key_sample;

    // --- Decodificador de Teclas ---
    // Mapea el código del teclado al valor numérico o comando
    assign key_code = 
        (key_sample == 4'h0) ? 4'd0 :
        (key_sample == 4'h1) ? 4'd1 :
        (key_sample == 4'h2) ? 4'd2 :
        (key_sample == 4'h3) ? 4'd3 :
        (key_sample == 4'h4) ? 4'd4 :
        (key_sample == 4'h5) ? 4'd5 :
        (key_sample == 4'h6) ? 4'd6 :
        (key_sample == 4'h7) ? 4'd7 :
        (key_sample == 4'h8) ? 4'd8 :
        (key_sample == 4'h9) ? 4'd9 :
        (key_sample == 4'hA) ? 4'd10 : // Tecla A -> DIVIDIR
        (key_sample == 4'hC) ? 4'd11 : // Tecla # -> CLEAR (mapeado desde C)
        (key_sample == 4'hE) ? 4'd0 :  // Tecla * -> 0 (alternativo)
        4'd15; // Ignorar otras teclas (B, D, F, etc.)

    // --- Instancia del Módulo de División ---
    module_division u_division (
        .clk(clk),
        .rst_n(rst_n),
        .start(div_start),
        .i_dividend(operand_1),
        .i_divisor(operand_2),
        .o_quotient(div_quotient),
        .o_remainder(div_remainder),
        .done(div_done),
        .error(div_error)
    );

    // --- Máquina de Estados de la Calculadora ---
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            operand_1 <= '0;
            operand_2 <= '0;
            display_reg <= '0;
            div_start <= 0;
        end else begin
            div_start <= 0; // El pulso de start dura un ciclo

            // El CLEAR es la máxima prioridad
            if (key_pulse && key_code == 11) begin // CLEAR (Tecla #)
                state <= S_IDLE;
                operand_1 <= '0;
                operand_2 <= '0;
                display_reg <= '0;
            end else begin
                case (state)
                    // En S_IDLE, preparamos para el primer operando.
                    S_IDLE: begin
                        operand_1 <= '0;
                        operand_2 <= '0;
                        display_reg <= '0;
                        state <= S_OPERAND_1;
                    end

                    S_OPERAND_1: begin
                        if (key_pulse) begin
                            if (key_code < 10) begin // Dígito 0-9
                                // Pre-chequeo de desborde (overflow) para 8 bits (max 255)
                                if (operand_1 < 25 || (operand_1 == 25 && key_code <= 5)) begin
                                    logic [7:0] next_operand_1;
                                    next_operand_1 = operand_1 * 10 + key_code;
                                    operand_1 <= next_operand_1;
                                    display_reg <= next_operand_1;
                                end
                            end else if (key_code == 10) begin // DIVIDIR (Tecla A)
                                state <= S_OPERAND_2;
                                operand_2 <= '0;
                                display_reg <= '0; // Limpiar display para el segundo operando
                            end
                        end
                    end

                    S_OPERAND_2: begin
                        if (key_pulse) begin
                            if (key_code < 10) begin // Dígito 0-9
                                // Pre-chequeo de desborde (overflow) para 8 bits (max 255)
                                if (operand_2 < 25 || (operand_2 == 25 && key_code <= 5)) begin
                                    logic [7:0] next_operand_2;
                                    next_operand_2 = operand_2 * 10 + key_code;
                                    operand_2 <= next_operand_2;
                                    display_reg <= next_operand_2;
                                end
                            end else if (key_code == 10) begin // DIVIDIR (actúa como IGUAL)
                                div_start <= 1;
                                state <= S_CALC;
                            end
                        end
                    end

                    S_CALC: begin
                        if (div_done) begin
                            if (div_error) begin
                                display_reg <= 16'hEEEE; // Error de división por cero
                            end else begin
                                display_reg <= div_quotient;
                            end
                            state <= S_RESULT;
                        end
                    end

                    S_RESULT: begin
                        // Espera a que se presione DIV para una nueva operación
                        // o CLEAR para reiniciar.
                        if (key_pulse && key_code == 10) begin // DIVIDIR
                            operand_1 <= div_quotient; // El resultado se vuelve el primer operando
                            operand_2 <= '0;
                            display_reg <= '0;
                            state <= S_OPERAND_2;
                        end
                    end
                endcase
            end
        end
    end

    // --- Conversión a BCD y Control del Display ---
    module_bin_to_bcd u_bin_to_bcd (
        .i_bin(display_reg[11:0]), // Convertimos un valor de 12 bits
        .o_bcd(bcd_out)
    );

    module_disp_controller u_display (
        .clk(clk),
        .rst(~rst_n),
        .data(bcd_out),
        .seg(segments),
        .an(anodos)
    );

    // --- Asignación de Salidas ---
    assign a = anodos;
    assign d = segments;

endmodule