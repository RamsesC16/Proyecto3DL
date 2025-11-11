`timescale 1ns/1ps

module module_division_BROKEN (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    input  logic [7:0]  i_dividend,
    input  logic [7:0]  i_divisor,
    output logic [7:0]  o_quotient,
    output logic [7:0]  o_remainder,
    output logic        done,
    output logic        error
);

    typedef enum logic [1:0] {IDLE, CALC, FINISH} state_t;
    state_t state, next_state;

    // Internal registers for the algorithm
    logic [8:0] A;
    logic [7:0] Q;
    logic [3:0] count;

    // Internal registers for outputs
    logic [7:0] quotient_reg;
    logic [7:0] remainder_reg;
    logic       done_reg;
    logic       error_reg;

    // Wires for intermediate calculations
    logic [8:0] A_op_result;
    logic       new_q_bit;
    logic [8:0] final_A;

    // Sequential logic for state and data registers
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= IDLE;
            A             <= '0;
            Q             <= '0;
            count         <= '0;
            quotient_reg  <= '0;
            remainder_reg <= '0;
            done_reg      <= 1'b0;
            error_reg     <= 1'b0;
        end else begin
            state <= next_state;
            
            // By default, output pulses are low
            done_reg  <= 1'b0;
            error_reg <= 1'b0;

            case (state)
                IDLE: begin
                    if (start) begin
                        if (i_divisor == 0) begin
                            error_reg     <= 1'b1;
                            done_reg      <= 1'b1;
                            quotient_reg  <= 'hFF; // Indicate error
                            remainder_reg <= 'hFF;
                        end else begin
                            A     <= 9'h000;
                            Q     <= i_dividend;
                            count <= 8;
                        end
                    end
                end

                CALC: begin
                    A     <= A_op_result;
                    Q     <= (Q << 1) | new_q_bit;
                    count <= count - 1;
                end

                FINISH: begin
                    quotient_reg  <= Q;
                    remainder_reg <= final_A[7:0];
                    done_reg      <= 1'b1;
                end
            endcase
        end
    end

    // Combinational logic
    always_comb begin
        logic [8:0] A_shifted;
        
        // Default assignments
        next_state = state;
        
        // Shift A and Q left
        A_shifted = {A[7:0], Q[7]};
        
        // Perform operation based on sign of A
        if (A[8] == 0) begin // If A is positive
            A_op_result = A_shifted - {1'b0, i_divisor};
        end else begin // If A is negative
            A_op_result = A_shifted + {1'b0, i_divisor};
        end

        // New quotient bit is the inverse of the result's sign bit
        new_q_bit = ~A_op_result[8];

        // Final remainder correction
        if (A[8] == 1) begin // If remainder (A) is negative
            final_A = A + {1'b0, i_divisor};
        end else begin
            final_A = A;
        end

        // State transitions
        case (state)
            IDLE: begin
                if (start) begin
                    if (i_divisor == 0) begin
                        next_state = IDLE; // Stay in IDLE, error is pulsed
                    end else begin
                        next_state = CALC;
                    end
                end
            end
            CALC: begin
                // After 7 cycles, count will be 1. On the 8th cycle, go to FINISH.
                if (count == 1) begin
                    next_state = FINISH;
                end
            end
            FINISH: begin
                next_state = IDLE;
            end
        endcase
    end

    // Assign internal registers to module outputs
    assign o_quotient  = quotient_reg;
    assign o_remainder = remainder_reg;
    assign done        = done_reg;
    assign error       = error_reg;

endmodule
