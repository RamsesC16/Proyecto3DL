module module_mux_41 (
    input  logic [1:0]  sel,
    input  logic [15:0] in_data,  // 2 entradas de 4 bits cada una = 8 bits en total
    output logic [3:0]  out_data
);

    assign out_data = (sel == 2'b00) ? in_data[3:0] :
                      (sel == 2'b01) ? in_data[7:4] :
                      (sel == 2'b10) ? in_data[11:8] :
                      (sel == 2'b11) ? in_data[15:12] : 4'b0;
endmodule