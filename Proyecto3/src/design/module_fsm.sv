module module_fsm (
    input  logic        clk,
    input  logic        reset,
    input  logic        press,
    output logic        [1:0]    y_AB,
    output logic         y_disp,
    output logic        reset_2
);
    logic [4:0] state, nextstate;
    parameter INICIO = 3'b000, 
    PRIMERO = 3'b001, 
    SEGUNDO = 3'b010, 
    DIVIDIR = 3'b100,
    RESET = 3'b111;
    initial begin
        state = INICIO;
    end
    

    // state register
    always_ff @(posedge clk, posedge reset)
        if (reset) begin 
            state <= INICIO;
        end 
        else begin
            state <= nextstate;
        end

    // Next state logic
    always_comb begin
        case (state)
            INICIO: begin
                if (press) nextstate = PRIMERO;
                else nextstate = INICIO;
            end
            PRIMERO: begin
                if (press) nextstate = SEGUNDO;
                else nextstate = PRIMERO;
            end
            SEGUNDO: begin
                if (press) nextstate = DIVIDIR;
                else nextstate = SEGUNDO;
            end
            DIVIDIR: begin
                if (press) nextstate = RESET;
                else nextstate = DIVIDIR;
            end
            RESET: begin
                nextstate = INICIO;
            end
            default: nextstate = INICIO;
        endcase
    end

    // Output logic
    always_comb begin
        case (state)
            INICIO: begin
                y_AB = 2'b01;
                y_disp = 1'b0;
                reset_2 = 1'b0;
            end
            PRIMERO: begin
                y_AB = 2'b10;
                y_disp = 1'b0;
                reset_2 = 1'b0;
            end
            SEGUNDO: begin
                y_AB = 2'b00;
                y_disp = 1'b0;
                reset_2 = 1'b0;
            end
            DIVIDIR: begin
                y_AB = 2'b00;
                y_disp = 1'b1;
                reset_2 = 1'b0;
            end
            RESET: begin
                y_AB = 2'b00;
                y_disp = 1'b0;
                reset_2 = 1'b1;
            end
            default: begin
                y_AB = 2'b00;
                y_disp = 1'b0;
                reset_2 = 1'b0;
            end
        endcase
    end
    
endmodule