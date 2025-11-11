
`timescale 1ns/1ps

module module_top_tb;

    // --- Conexiones al DUT ---
    logic clk;
    reg [3:0] filas_raw;
    wire [3:0] columnas;
    wire [3:0] a;
    wire [6:0] d;

    // --- Instancia del DUT (Device Under Test) ---
    module_top dut (
        .clk(clk),
        .columnas(columnas),
        .filas_raw(filas_raw),
        .a(a),
        .d(d)
    );

    // --- Generador de Reloj ---
    always #5 clk = ~clk; // Reloj de 100MHz

    // --- Lógica de Simulación del Teclado ---
    reg [3:0] key_to_press = 4'hF; // Tecla que se desea presionar (F = ninguna)

    // Este bloque simula la matriz del teclado.
    // Responde a la columna que el DUT activa (pone en bajo)
    // y, si hay una tecla que presionar, pone la fila correspondiente en bajo.
    always @* begin
        filas_raw = 4'b1111; // Por defecto, ninguna fila está activa
        if (key_to_press != 4'hF) begin
            case (columnas)
                // Columna 0 activa (1110)
                4'b1110: case (key_to_press)
                    4'h1: filas_raw = 4'b1110;
                    4'h4: filas_raw = 4'b1101;
                    4'h7: filas_raw = 4'b1011;
                    4'hE: filas_raw = 4'b0111; // Tecla '*'
                endcase
                // Columna 1 activa (1101)
                4'b1101: case (key_to_press)
                    4'h2: filas_raw = 4'b1110;
                    4'h5: filas_raw = 4'b1101;
                    4'h8: filas_raw = 4'b1011;
                    4'h0: filas_raw = 4'b0111;
                endcase
                // Columna 2 activa (1011)
                4'b1011: case (key_to_press)
                    4'h3: filas_raw = 4'b1110;
                    4'h6: filas_raw = 4'b1101;
                    4'h9: filas_raw = 4'b1011;
                    4'hC: filas_raw = 4'b0111; // Tecla '#'
                endcase
                // Columna 3 activa (0111)
                4'b0111: case (key_to_press)
                    4'hA: filas_raw = 4'b1110; // Tecla 'A'
                    4'hB: filas_raw = 4'b1101; // Tecla 'B'
                    4'hD: filas_raw = 4'b1011; // Tecla 'C'
                endcase
            endcase
        end
    end

    // --- Tarea para Simular Pulsación de Tecla ---
    task press_key(input [3:0] key, input int duration_ms);
        $display("TB: Presionando tecla %h por %d ms...", key, duration_ms);
        key_to_press = key;
        #(duration_ms * 1_000_000); // Convertir ms a ns
        key_to_press = 4'hF; // Soltar la tecla
        $display("TB: Tecla %h liberada.", key);
        #10_000_000; // Pausa de 10ms entre pulsaciones
    endtask

    // --- Secuencia Principal de Prueba ---
    initial begin
        $dumpfile("module_top_tb.vcd");
        $dumpvars(0, module_top_tb);

        clk = 0;
        filas_raw = 4'b1111;
        key_to_press = 4'hF;

        // Esperar a que el reset interno del DUT finalice
        wait (dut.rst_n == 1'b1);
        $display("TB: Reset del sistema finalizado. Comenzando pruebas.");
        #1000;

        // --- Test Case 1: 100 / 8 = 12 ---
        $display("TB: --- INICIO CASO DE PRUEBA: 100 / 8 ---");
        press_key(4'h1, 50);
        press_key(4'h0, 50);
        press_key(4'h0, 50);
        @(posedge clk); // Sincronizar para leer el valor actualizado
        if (dut.display_reg == 100) $display("TB: OK -> Operando 1 es 100.");
        else $error("TB: FALLO -> Se esperaba 100, pero el display tiene %d.", dut.display_reg);

        press_key(4'hA, 50); // Tecla DIV (A)
        @(posedge clk); // Sincronizar para leer el estado actualizado
        if (dut.state == dut.S_OPERAND_2) $display("TB: OK -> Estado es S_OPERAND_2.");
        else $error("TB: FALLO -> Estado incorrecto después de DIV.");

        press_key(4'h8, 50);
        @(posedge clk); // Sincronizar para leer el valor actualizado
        if (dut.display_reg == 8) $display("TB: OK -> Operando 2 es 8.");
        else $error("TB: FALLO -> Se esperaba 8, pero el display tiene %d.", dut.display_reg);

        press_key(4'hA, 50); // Tecla DIV (actúa como IGUAL)
        $display("TB: Calculando...");
        wait (dut.div_done == 1'b1);
        @(posedge clk); // Sincronizar para que el resultado se cargue

        if (dut.display_reg == 12) $display("TB: OK -> Resultado es 12.");
        else $error("TB: FALLO -> Se esperaba 12, pero el resultado es %d.", dut.display_reg);
        $display("TB: --- FIN CASO DE PRUEBA: 100 / 8 ---");

        #50_000_000; // Pausa de 50ms

        // --- Test Case 2: CLEAR ---
        $display("TB: --- INICIO CASO DE PRUEBA: CLEAR ---");
        press_key(4'hC, 50); // Tecla CLEAR (#)
        if (dut.display_reg == 0) $display("TB: OK -> Display reseteado a 0.");
        else $error("TB: FALLO -> Se esperaba 0, pero el display tiene %d.", dut.display_reg);
        if (dut.state == dut.S_IDLE) $display("TB: OK -> Estado es S_IDLE.");
        else $error("TB: FALLO -> Estado incorrecto después de CLEAR.");
        $display("TB: --- FIN CASO DE PRUEBA: CLEAR ---");

        $display("TB: Todas las pruebas han finalizado.");
        $finish;
    end

endmodule
