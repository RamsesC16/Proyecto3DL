module module_division (
    input  logic i_dividend,
    input  logic i_divisor,
    output logic o_quotient,
    output logic o_error
);

    assign o_quotient = i_dividend & i_divisor; 
    assign o_error    = ~i_divisor;

endmodule