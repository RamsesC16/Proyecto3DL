module lecture (
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  row_debounced,   // filas ya filtradas por DeBounce
    output logic [3:0]  col,             // columnas activas
    output logic        key_valid,       // bandera de tecla válida
    output logic [3:0]  key_code         // código de la tecla (0-F)
);

    // Escaneo de columnas
    logic [1:0] col_index;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            col_index <= 0;
        end else begin
            col_index <= col_index + 1;
        end
    end

    assign col = 4'b1111 ^ (1 << col_index); // activa una columna a la vez

    // Decodificación de tecla
    always_comb begin
        key_valid = 0;
        key_code  = 4'h0;

        case (col_index)
            2'd0: begin
                if (row_debounced[0]) begin key_valid=1; key_code=4'h1; end
                if (row_debounced[1]) begin key_valid=1; key_code=4'h4; end
                if (row_debounced[2]) begin key_valid=1; key_code=4'h7; end
                if (row_debounced[3]) begin key_valid=1; key_code=4'hE; end
            end
            2'd1: begin
                if (row_debounced[0]) begin key_valid=1; key_code=4'h2; end
                if (row_debounced[1]) begin key_valid=1; key_code=4'h5; end
                if (row_debounced[2]) begin key_valid=1; key_code=4'h8; end
                if (row_debounced[3]) begin key_valid=1; key_code=4'h0; end
            end
            2'd2: begin
                if (row_debounced[0]) begin key_valid=1; key_code=4'h3; end
                if (row_debounced[1]) begin key_valid=1; key_code=4'h6; end
                if (row_debounced[2]) begin key_valid=1; key_code=4'h9; end
                if (row_debounced[3]) begin key_valid=1; key_code=4'hF; end
            end
            2'd3: begin
                if (row_debounced[0]) begin key_valid=1; key_code=4'hA; end
                if (row_debounced[1]) begin key_valid=1; key_code=4'hB; end
                if (row_debounced[2]) begin key_valid=1; key_code=4'hC; end
                if (row_debounced[3]) begin key_valid=1; key_code=4'hD; end
            end
        endcase
    end

endmodule