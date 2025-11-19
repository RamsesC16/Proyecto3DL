`timescale 1 ns / 100 ps
module module_DeBounce 
	(
	input 			clk, n_reset, button_in,
	output reg 	DB_out				
	);

  parameter N = 10 ;      // Utilizar N=10 para acortar la simulación

//
  
////---------------- Variables Internas ---------------
	// Parámetros adicionales
	parameter N_PULSE = 1;  // 1 ciclo de reloj = 37ns a 27MHz (mínimo posible)
	parameter N_INHIBIT = 20; // Tiempo de inhibición independiente (2^(18-1))/27MHz = 4.85ms
	
	// Variables internas ampliadas
	reg  [N-1 : 0]	q_reg;							// contador para debounce inicial
	reg  [N-1 : 0]	q_next;
	reg  [N_INHIBIT-1 : 0] inhibit_reg;				// contador para tiempo de inhibición
	reg  [N_INHIBIT-1 : 0] inhibit_next;
	reg  [N_PULSE-1 : 0] pulse_counter;				// contador para duración del pulso
	reg DFF1, DFF2;									// flip-flops de entrada
	wire q_add;											// flags de control
	wire q_reset;
	wire inhibit_add;									// flags para contador de inhibición
	wire inhibit_reset;
	
	// Estados de la máquina
	reg [2:0] current_state;
	parameter IDLE         = 3'b000;    // Esperando entrada estable alta
	parameter PULSE_ACTIVE = 3'b001;    // Pulso de 10ms activo
	parameter WAIT_LOW     = 3'b010;    // Esperando entrada baje
	parameter INHIBITED    = 3'b011;    // Inhibido hasta entrada estable baja por 39ms
//// ------------------------------------------------------

////asignaciones continuas para control del contador
	assign q_reset = (DFF1 ^ DFF2);		// XOR para detectar cambio de nivel
	assign q_add = ~(q_reg[N-1]);			// sumar cuando MSB = 0
	assign inhibit_reset = (DFF1 ^ DFF2);	// XOR para detectar cambio de nivel
	assign inhibit_add = ~(inhibit_reg[N_INHIBIT-1]);	// sumar cuando MSB = 0
	
//// contador combinacional para q_next	
	always @ ( q_reset, q_add, q_reg)
		begin
			case({q_reset , q_add})
				2'b00 :
						q_next <= q_reg;
				2'b01 :
						q_next <= q_reg + 1;
				default :
						q_next <= { N {1'b0} };
			endcase 	
		end

//// contador combinacional para inhibit_next	
	always @ ( inhibit_reset, inhibit_add, inhibit_reg)
		begin
			case({inhibit_reset , inhibit_add})
				2'b00 :
						inhibit_next <= inhibit_reg;
				2'b01 :
						inhibit_next <= inhibit_reg + 1;
				default :
						inhibit_next <= { N_INHIBIT {1'b0} };
			endcase 	
		end
	
//// Actualización de flip-flops, contadores y máquina de estados
	always @ ( posedge clk )
		begin
			if(n_reset ==  1'b0)
				begin
					DFF1 <= 1'b0;
					DFF2 <= 1'b0;
					q_reg <= { N {1'b0} };
					inhibit_reg <= { N_INHIBIT {1'b0} };
					current_state <= IDLE;
					pulse_counter <= { N_PULSE {1'b0} };
					DB_out <= 1'b0;
				end
			else
				begin
					DFF1 <= button_in;
					DFF2 <= DFF1;
					q_reg <= q_next;
					inhibit_reg <= inhibit_next;
					
					// Máquina de estados
					case (current_state)
						IDLE: begin
							pulse_counter <= { N_PULSE {1'b0} };
							DB_out <= 1'b0;
							// Entrada estable alta por 39ms -> activar pulso
							if (q_reg[N-1] == 1'b1 && DFF2 == 1'b1) begin
								current_state <= PULSE_ACTIVE;
							end
						end
						
						PULSE_ACTIVE: begin
							// Generar pulso de exactamente 1 ciclo
							DB_out <= 1'b1;  // Activar por 1 ciclo
							current_state <= WAIT_LOW;  // Inmediatamente pasar al siguiente estado
						end
						
						WAIT_LOW: begin
							pulse_counter <= { N_PULSE {1'b0} };
							DB_out <= 1'b0;
							// Esperar que la entrada baje
							if (DFF2 == 1'b0) begin
								current_state <= INHIBITED;
							end
						end
						
						INHIBITED: begin
							pulse_counter <= { N_PULSE {1'b0} };
							DB_out <= 1'b0;
							// Entrada estable baja por tiempo N_INHIBIT -> volver a IDLE
							if (inhibit_reg[N_INHIBIT-1] == 1'b1 && DFF2 == 1'b0) begin
								current_state <= IDLE;
							end
						end
						
						default: begin
							current_state <= IDLE;
							pulse_counter <= { N_PULSE {1'b0} };
							DB_out <= 1'b0;
						end
					endcase
				end
		end

	endmodule