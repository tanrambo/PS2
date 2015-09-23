`timescale 1ns / 1ps

module Maquina_FSM(CLK_ROSHI, reset, silenciar, sensores, Z, state);
	input wire CLK_ROSHI, reset, silenciar; //reset: reinicia la maquina, silenciar apaga el led de alarma sonora.
	input wire [3:0] sensores;	//Sensores activos.
	output reg [2:0] Z, state; //Z se refiere a las salidas: 'alarma sonora' y 'led de emergencia y led de alerta'.

	reg X, Y;
	reg [2:0] ESTADO_ACTUAL, ESTADO_SIGUIENTE;
	parameter [2:0] S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;
	
	initial begin
		ESTADO_ACTUAL <= S0;
		ESTADO_SIGUIENTE <= S0;
		Z <= S0;
	end
	
	always @ (sensores) begin
		X <= (sensores[1] | sensores[0] | sensores[2] | sensores[3]); //dato
		Y <= ((sensores[1] & sensores[0]) | sensores[2] | sensores[3]); //emergencia
	end
	
	always @ (posedge CLK_ROSHI) begin
		if (reset) ESTADO_ACTUAL <= S0;
		else ESTADO_ACTUAL <= ESTADO_SIGUIENTE;
	end		
	
	always @ (ESTADO_ACTUAL or X or Y or silenciar) begin
		case(ESTADO_ACTUAL)
			S0:	
				if(X) ESTADO_SIGUIENTE <= S1;
				else ESTADO_SIGUIENTE <= S0;
			S1:		
				if(Y) ESTADO_SIGUIENTE <= S3;
				else ESTADO_SIGUIENTE <= S2;
			S2:
				if(silenciar) ESTADO_SIGUIENTE <= S4;
				else ESTADO_SIGUIENTE <= S0;
			S3:		
				if(silenciar) ESTADO_SIGUIENTE <= S4;
				else ESTADO_SIGUIENTE <= S0;
			S4:		
				ESTADO_SIGUIENTE <= S0;
			default:
				ESTADO_SIGUIENTE <= S0;
		endcase
	end
	
	always @ (ESTADO_ACTUAL or Y or silenciar) begin
		case(ESTADO_ACTUAL)
			S0:	
				Z <= S0;
			S1:		
				Z <= S0;
			S2:
				if (silenciar) Z <= S2;
				else Z <= S6; 
			S3:		
				if (silenciar) Z <= S1;
				else Z <= S5;
			S4:		
				if (Y) Z <= S1;
				else Z <= S2;
			default:
				Z <= S0;
		endcase
		state <= ESTADO_ACTUAL;
	end
endmodule
