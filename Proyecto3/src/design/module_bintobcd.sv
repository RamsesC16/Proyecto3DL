module module_bintobcd# (
    parameter WIDTH_IN = 4,
    parameter WIDTH_OUT = 8
)(
    input  logic [WIDTH_IN-1:0]  bin_1,
    input  logic [WIDTH_IN-1:0]  bin_2,
    output logic [WIDTH_OUT-1:0] bcd_1,
    output logic [WIDTH_OUT-1:0] bcd_2
);
    integer i;
    logic [WIDTH_OUT+WIDTH_IN-1:0] shift_reg_1;
    logic [WIDTH_OUT+WIDTH_IN-1:0] shift_reg_2;
    
    always_comb begin
        // Inicializar: parte BCD en 0, parte binaria con el valor de entrada
        shift_reg_1 = {{WIDTH_OUT{1'b0}}, bin_1};
        shift_reg_2 = {{WIDTH_OUT{1'b0}}, bin_2};
        
        // Algoritmo Double Dabble: iterar sobre cada bit del binario
        for (i = 0; i < WIDTH_IN; i = i + 1) begin
            // Ajustar cada dígito BCD si es mayor o igual a 5 (antes del shift)
            if (shift_reg_1[WIDTH_IN+3:WIDTH_IN] >= 5)
                shift_reg_1[WIDTH_IN+3:WIDTH_IN] = shift_reg_1[WIDTH_IN+3:WIDTH_IN] + 4'd3;
            if (shift_reg_1[WIDTH_IN+7:WIDTH_IN+4] >= 5)
                shift_reg_1[WIDTH_IN+7:WIDTH_IN+4] = shift_reg_1[WIDTH_IN+7:WIDTH_IN+4] + 4'd3;
            
            if (shift_reg_2[WIDTH_IN+3:WIDTH_IN] >= 5)
                shift_reg_2[WIDTH_IN+3:WIDTH_IN] = shift_reg_2[WIDTH_IN+3:WIDTH_IN] + 4'd3;
            if (shift_reg_2[WIDTH_IN+7:WIDTH_IN+4] >= 5)
                shift_reg_2[WIDTH_IN+7:WIDTH_IN+4] = shift_reg_2[WIDTH_IN+7:WIDTH_IN+4] + 4'd3;
            
            // Desplazar a la izquierda
            shift_reg_1 = shift_reg_1 << 1;
            shift_reg_2 = shift_reg_2 << 1;
        end
        
        // Extraer los dígitos BCD de la parte superior del registro
        bcd_1 = shift_reg_1[WIDTH_OUT+WIDTH_IN-1:WIDTH_IN];
        bcd_2 = shift_reg_2[WIDTH_OUT+WIDTH_IN-1:WIDTH_IN];
    end

endmodule