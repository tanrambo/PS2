`timescale 1ns / 1ps

module Lol(CLK_chaos, restart, dato, sensores, B, reinicio);
	input wire CLK_chaos, restart;	// restart: reinicia los datos almacenados por los registros locales.
	input wire [7:0] dato;		//Dato recibido del teclado.
	output reg [3:0] sensores;	//Datp que indica los sensores activos.
	output reg B; 	// Apaga el led que representa la alarma sonora.
	output reg reinicio;		//Reinicia la maquina de estados del primer proyecto (FSM).

	reg [2:0] STA, STN;	//Estado actual y proximo, respectivamente.
	reg [5:0] salidas;	//Registro local que almacena estado de los sensores, reinicio y B.
	localparam [7:0] corto = 8'h21, gas = 8'h34, humo = 8'h33, tup = 8'h2C, enter = 8'h5A, reset = 8'h2D, silenciar = 8'h1B;
	localparam [2:0] ST0 = 3'b000, ST1 = 3'b001, ST2 = 3'b010, ST3 = 3'b011, ST4 = 3'b100, ST5 = 3'b101, ST6 = 3'b110;
	
	initial begin
		STA = 3'b000;
		sensores = 4'h0;
		salidas = 6'b000000;	
	end
		
	always @ (posedge CLK_chaos, posedge restart) begin // Reset o cambio de estado dependiendo de RS
		if(restart) STA <= ST0;
		else STA <= STN;
	end

	always @ (posedge CLK_chaos) begin
		case (STA)
			ST0:									// Si se apreta 'R' condiciona el reset.
				if (dato == reset) begin
					salidas[5] <= 1'b1;		//salidas[5] corresponde al bit de reinicio.
					STN <= ST0;
					salidas[4:0] <= 5'b00000;
				end
				else begin 
					STN <= ST1;				//Si el dato es diferente de 'R', se prosigue con la verificacion. 
					salidas[5] <= 1'b0;
				end
				
			ST1:									// Si hay corto (tecla 'C') coloca el bit en salidas[3].
				if (dato == corto) begin
					salidas[3] <= 1'b1;
					STN <= ST0;
				end
				else STN <= ST2;				//Si no, prosigue con los demas estados.
				
			ST2:									// Si hay corto (tecla 'C') coloca el bit en salidas[2].
				if (dato == gas) begin
					salidas[2] <= 1'b1;
					STN <= ST0;
				end
				else STN <= ST3;				//Si no, prosigue con los demas estados.
				
			ST3:									// Si hay corto (tecla 'H') coloca el bit en salidas[1].
				if (dato == humo) begin
					salidas[1] <= 1'b1;
					STN <= ST0;
				end
				else STN <= ST4;				//Si no, prosigue con los demas estados.
				
			ST4:									
				if (dato == silenciar) begin	// Si se ordena silenciar (tecla 'S') coloca el bit en salidas[4].
					salidas[4] <= 1'b1;
					STN <= ST0;
				end
				else STN <= ST5;					//Si no, prosigue con los demas estados.
			
			ST5:
				if (dato == tup) begin			// Si se ordena silenciar (tecla 'S') coloca el bit en salidas[0].
					salidas[0] <= 1'b1;
					STN <= ST0;
				end
				else STN <= ST6;					//Si no, prosigue con el ultimo estado.
					
			ST6:
				if (dato == enter) begin		//Si se presiona enter, envia los datos registrados a la maquina de estados FSM.
					sensores <= salidas[3:0];
					B <= salidas[4];
					reinicio <= salidas[5];
					STN <= ST0;
				end
				else STN <= ST0;					//De lo contrario, vuelve a iniciar la revision de estados.
			
			default: STN <= ST0;
		endcase
	end
endmodule
