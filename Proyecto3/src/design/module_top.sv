module module_top (
    input  logic        clk,
    input  logic [3:0]  fil,
    input  logic        rst_in,
    output logic        rst_1,
    output logic [3:0]  col,
    output logic [6:0]  seg,
    output logic        seg_dot,
    output logic [3:0]  cats
);
    logic [3:0]  numero;
    logic        reset;
    logic        save;
    logic press;
    assign rst_1 = 1'b1;
    module_lectura #(.WIDTH(4)) SDL (
        .clk(clk),
        .col(col),
        .fil(fil),
        .press_DB(press),
        .numero(numero),
        .reset(reset),
        .rst_in(rst_in),
        .save(save)
    );

    logic  sel_disp;
    logic [1:0] sel_AB;
    logic reset_combined;
    logic reset_2;
    assign reset_combined = reset | reset_2;

    module_fsm fsm (
        .clk(clk),
        .reset(reset),
        .reset_2(reset_2),
        .press(press),
        .y_AB(sel_AB),
        .y_disp(sel_disp)
    );

    logic [15:0] digitos;
    
    logic [3:0] A,B;
    module_register #(.WIDTH(4)) RA (
        .clk(clk),
        .reset(reset_combined),
        //.en(selector[0]),
        .en(press & sel_AB[0]), // Siempre habilitado para capturar el primer dígito
        .d(numero),
        .q(A)
    );

    module_register #(.WIDTH(4)) RB (
        .clk(clk),
        .reset(reset_combined),
        //.en(selector[1]),
        .en(press & sel_AB[1]),
        .d(numero),
        .q(B)
    );

    assign digitos = {4'b1000, A, B, 4'b1000};

    logic [7:0] digitos_COC;
    logic [7:0] digitos_RES;
    logic [3:0] digitos_COC_bin;
    logic [3:0] digitos_RES_bin;

    module_divisor divisor (
        .clk(clk),
        .A(A),
        .B(B),
        .R(digitos_RES_bin),
        .Q(digitos_COC_bin)
    );

    module_bintobcd bcd (
        .bin_1(digitos_COC_bin),
        .bin_2(digitos_RES_bin),
        .bcd_1(digitos_COC),
        .bcd_2(digitos_RES)
    );
    
    logic [3:0] digito;
    logic [1:0] sel_digitos;

    module_contador contador(
        .clk(clk),
        .sel(sel_digitos)
    );

    // Cambio de dígitos a 1kHz
    module_mux_41 seleccion (
        .sel(sel_digitos),
        .in_data(digitos),
        .out_data(digito)
    );

    logic [3:0] digito_2;

    module_mux_41 seleccion_2 (
        .sel(sel_digitos),
        .in_data({digitos_COC, digitos_RES}),
        .out_data(digito_2)
    );

    logic [3:0] num;
    module_mux_21 seleccion_final (
        .sel(sel_disp),
        .in_1(digito),
        .in_2(digito_2),
        .out_data(num)
    );
    // Barrido de cátodos a 1kHz
    module_barrido #(
        .ACTIVE_LOW(1'b1) // Salida active-low para cátodo común
    ) BC (
        .apagar(~sel_disp),
        .clk(clk),
        .col(cats)
    );
    
    module_sevenseg D7S (
        .num(num),
        .seg(seg)
    );
    assign seg_dot = 1'b0; // punto desactivado

endmodule