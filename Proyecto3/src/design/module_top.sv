module top (
    input  logic        clk,
    input  logic        rst,
    input  logic [3:0]  row,   // filas del teclado físico
    output logic [3:0]  col,   // columnas del teclado
    output logic [6:0]  seg,   // segmentos display
    output logic [3:0]  an     // anodos display
);

    // Señales internas
    logic        key_valid;
    logic [3:0]  key_code;
    logic [3:0]  row_debounced;

    logic [15:0] A_reg, B_reg;
    logic        sign_A, sign_B;
    logic        start_div, valid_div;
    logic [15:0] Q_out, R_out;
    logic        sign_Q, sign_R;
    logic        done_div, error_div0;

    logic [15:0] bcd_out;
    logic [3:0]  mux_out;
    logic [6:0]  seg_dec;

    // 1. Filtrado robusto de rebote
    DeBounce db_inst (
        .clk(clk),
        .rst(rst),
        .key_in(row),
        .key_out(row_debounced)
    );

    // 2. Escaneo y decodificación del teclado
    lecture lect_inst (
        .clk(clk),
        .rst(rst),
        .row_debounced(row_debounced),
        .col(col),
        .key_valid(key_valid),
        .key_code(key_code)
    );

    // 3. Controlador de entrada (FSM)
    input_controller ic_inst (
        .clk(clk),
        .rst(rst),
        .key_valid(key_valid),
        .key_code(key_code),
        .start_div(start_div),
        .valid_div(valid_div),
        .A_reg(A_reg),
        .B_reg(B_reg),
        .sign_A(sign_A),
        .sign_B(sign_B)
    );

    // 4. Módulo de cálculo (ejemplo con divisor)
    div_unit_pipelined #(.N(16), .STAGES(4)) div_inst (
        .clk(clk),
        .rst(rst),
        .start(start_div),
        .valid(valid_div),
        .A_in(A_reg),
        .B_in(B_reg),
        .sign_A(sign_A),
        .sign_B(sign_B),
        .Q_out(Q_out),
        .R_out(R_out),
        .sign_Q(sign_Q),
        .sign_R(sign_R),
        .done(done_div),
        .error_div0(error_div0)
    );

    // 5. Conversión binario a BCD
    bin_to_bcd bcd_inst (
        .clk(clk),
        .rst(rst),
        .bin(Q_out),   // ejemplo: convertir cociente
        .bcd(bcd_out)
    );

    // 6. Multiplexor de dígitos
    mux mux_inst (
        .clk(clk),
        .rst(rst),
        .in(bcd_out),
        .out(mux_out)
    );

    // 7. Decodificador de segmentos
    disp_dec dec_inst (
        .clk(clk),
        .rst(rst),
        .digit(mux_out),
        .seg(seg_dec)
    );

    // 8. Controlador de displays
    disp_controller disp_inst (
        .clk(clk),
        .rst(rst),
        .seg(seg_dec),
        .an(an),
        .seg_out(seg)
    );

endmodule