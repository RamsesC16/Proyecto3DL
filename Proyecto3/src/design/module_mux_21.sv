module module_mux_21 (
    input  logic        sel,
    input  logic [3:0]  in_1,  // 2 entradas de 4 bits cada una = 8 bits en total
    input  logic [3:0]  in_2,
    output logic [3:0]  out_data
);

    assign out_data = (sel) ? in_2 : in_1;
endmodule
