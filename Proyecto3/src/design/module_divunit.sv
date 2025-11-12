module div_unit_pipelined_blocks #(
    parameter int N       = 16,
    parameter int STAGES  = 4   // número de bloques/etapas
)(
    input  logic                    clk,
    input  logic                    rst,
    input  logic                    start,
    input  logic                    valid,
    input  logic signed [N-1:0]     A_in,
    input  logic signed [N-1:0]     B_in,

    output logic signed [N-1:0]     Q_out,
    output logic signed [N-1:0]     R_out,
    output logic                    done,
    output logic                    error_div0
);

    // Estados
    typedef enum logic [1:0] {IDLE, RUN, DONE} state_t;
    state_t state, next_state;

    // Signos latcheados
    logic neg_Q, neg_R;

    // Pipeline de magnitudes y resultados parciales
    logic        valid_pipe   [0:STAGES];
    logic signed [N-1:0] A_mag_pipe [0:STAGES];
    logic signed [N-1:0] B_mag_pipe [0:STAGES];
    logic signed [N-1:0] Q_pipe     [0:STAGES];
    logic signed [N-1:0] R_pipe     [0:STAGES];

    // Control de error div/0 latcheado
    logic div0_latched;

    // Función para obtener rango de bits del bloque i
    function automatic int blk_size();
        return N / STAGES; // asumir división exacta
    endfunction

    function automatic int hi_bit(input int i); // i: índice de etapa
        return N - 1 - (i * blk_size());
    endfunction

    function automatic int lo_bit(input int i);
        return hi_bit(i) - (blk_size() - 1);
    endfunction

    // Secuencial: estado y registros
    integer k;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            done         <= 1'b0;
            error_div0   <= 1'b0;
            div0_latched <= 1'b0;
            neg_Q        <= 1'b0;
            neg_R        <= 1'b0;
            Q_out        <= '0;
            R_out        <= '0;

            for (k = 0; k <= STAGES; k++) begin
                valid_pipe[k] <= 1'b0;
                A_mag_pipe[k] <= '0;
                B_mag_pipe[k] <= '0;
                Q_pipe[k]     <= '0;
                R_pipe[k]     <= '0;
            end
        end else begin
            state <= next_state;
            done  <= 1'b0; // se pulsea en DONE

            unique case (state)
                IDLE: begin
                    error_div0   <= 1'b0;
                    div0_latched <= 1'b0;

                    if (start && valid) begin
                        if (B_in == 0) begin
                            // División por cero: salida inmediata segura
                            div0_latched <= 1'b1;
                            error_div0   <= 1'b1;
                            Q_out        <= '0;
                            R_out        <= A_in;
                        end else begin
                            // Latch de signos y magnitudes
                            neg_Q            <= (A_in < 0) ^ (B_in < 0);
                            neg_R            <= (A_in < 0);
                            A_mag_pipe[0]    <= (A_in < 0) ? -A_in : A_in;
                            B_mag_pipe[0]    <= (B_in < 0) ? -B_in : B_in;
                            Q_pipe[0]        <= '0;
                            R_pipe[0]        <= '0;

                            // Limpiar resto del pipeline
                            for (k = 1; k <= STAGES; k++) begin
                                valid_pipe[k] <= 1'b0;
                                A_mag_pipe[k] <= '0;
                                B_mag_pipe[k] <= '0;
                                Q_pipe[k]     <= '0;
                                R_pipe[k]     <= '0;
                            end
                            valid_pipe[0] <= 1'b1;
                        end
                    end
                end

                RUN: begin
                    // Avance por etapas: cada una procesa su rango lo..hi
                    integer i, j;
                    for (i = 0; i < STAGES; i++) begin
                        if (valid_pipe[i]) begin
                            logic signed [N-1:0] R_tmp, Q_tmp;
                            R_tmp = R_pipe[i];
                            Q_tmp = Q_pipe[i];

                            // Procesar bits del bloque i: desde hi_bit(i) hasta lo_bit(i)
                            for (j = hi_bit(i); j >= lo_bit(i); j--) begin
                                R_tmp = (R_tmp << 1) | ((A_mag_pipe[i] >> j) & 1);
                                if (R_tmp >= B_mag_pipe[i]) begin
                                    R_tmp       = R_tmp - B_mag_pipe[i];
                                    Q_tmp[j]    = 1'b1;
                                end else begin
                                    Q_tmp[j]    = 1'b0;
                                end
                            end

                            // Pasar acumulado a la siguiente etapa
                            Q_pipe[i+1]     <= Q_tmp;
                            R_pipe[i+1]     <= R_tmp;
                            A_mag_pipe[i+1] <= A_mag_pipe[i]; // mismo dividendo (magnitud)
                            B_mag_pipe[i+1] <= B_mag_pipe[i]; // mismo divisor (magnitud)
                            valid_pipe[i+1] <= 1'b1;
                            valid_pipe[i]   <= 1'b0;
                        end
                    end

                    // Al completar la última etapa (STAGES), preparar salidas con signos
                    if (valid_pipe[STAGES]) begin
                        Q_out      <= neg_Q ? -Q_pipe[STAGES] : Q_pipe[STAGES];
                        R_out      <= neg_R ? -R_pipe[STAGES] : R_pipe[STAGES];
                    end
                end

                DONE: begin
                    done       <= 1'b1;            // pulso de finalización
                    error_div0 <= div0_latched;     // mantener bandera si hubo div/0
                end
            endcase
        end
    end

    // Combinacional: próxima transición
    always_comb begin
        next_state = state;
        unique case (state)
            IDLE: begin
                if (start && valid) begin
                    if (B_in == 0)        next_state = DONE; // ya forzamos salida segura
                    else                  next_state = RUN;
                end
            end
            RUN: begin
                // DONE cuando la última etapa valida sus datos
                if (valid_pipe[STAGES])  next_state = DONE;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule