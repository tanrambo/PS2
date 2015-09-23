`timescale 1ns / 1ps

module Maq_7seg(clk, estado, sensores, display1);
	input clk;
	input [2:0] estado;				//Estado de la maquina FSM.
	input wire [3:0] sensores;		//Sensores activos.
	output reg [10:0] display1;	//Comandos para los siete segmentos.

	localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
	reg [1:0] count;	
	
	initial begin
		display1 <= 11'b11111111111;
		count <= 2'b00;
	end

	always @(posedge clk) begin
		count = count + 1'b1;
	end
	
	always @ (posedge clk) begin
		case (count)
			S0:				//Muestra el numero de estado en el primer segmento (de izquierda a derecha).
				if (estado == 3'b000) display1[10:0] <= 11'b01111000000;			
				else if (estado == 3'b001) display1[10:0] <= 11'b01111111001;
				else if (estado == 3'b010) display1[10:0] <= 11'b01110100100;
				else if (estado == 3'b011) display1[10:0] <= 11'b01110110000;
				else if (estado == 3'b100) display1[10:0] <= 11'b01110011001;
				else display1[10:0] <= 11'b11111111111;
			S1:				//Los demas muestran los sensores activos.
				if (sensores == 4'h7) display1[10:0] <= 11'b10110010000;
				else if (sensores == 4'hb) display1[10:0] <= 11'b10111000110;
				else if (sensores == 4'hd) display1[10:0] <= 11'b10111000110;
				else if (sensores == 4'he) display1[10:0] <= 11'b10111000110;
				else if (sensores == 4'hf) display1[10:0] <= 11'b10110001000;
				else display1[10:0] <= 11'b11111111111;
			S2:
			   if (sensores == 4'h3) display1[10:0] <= 12'b11010001001;
				else if (sensores == 4'h5) display1[10:0] <= 12'b11010010000;
				else if (sensores == 4'h6) display1[10:0] <= 12'b11010010000;
				else if (sensores == 4'h7) display1[10:0] <= 12'b11010001001;
				else if (sensores == 4'h9) display1[10:0] <= 12'b11011000110;
				else if (sensores == 4'ha) display1[10:0] <= 12'b11011000110;
				else if (sensores == 4'hb) display1[10:0] <= 12'b11010001001;
				else if (sensores == 4'hc) display1[10:0] <= 12'b11011000110;
				else if (sensores == 4'hd) display1[10:0] <= 12'b11010010000;
				else if (sensores == 4'he) display1[10:0] <= 12'b11010010000;
				else if (sensores == 4'hf) display1[10:0] <= 12'b11011000111;
				else display1[10:0] <= 11'b11111111111;
			S3:
				if (sensores == 4'h1) display1[10:0] <= 11'b11100000111;
				else if (sensores == 4'h2)	display1[10:0] <= 11'b11100001001;
				else if (sensores == 4'h3) display1[10:0] <= 11'b11100000111;
				else if (sensores == 4'h4) display1[10:0] <= 11'b11100010000;
				else if (sensores == 4'h5) display1[10:0] <= 11'b11100000111;
				else if (sensores == 4'h6) display1[10:0] <= 11'b11100001001;
				else if (sensores == 4'h7) display1[10:0] <= 11'b11100000111;
				else if (sensores == 4'h8) display1[10:0] <= 11'b11101000110;
				else if (sensores == 4'h9) display1[10:0] <= 11'b11100000111;
				else if (sensores == 4'ha) display1[10:0] <= 11'b11100001001;
				else if (sensores == 4'hb) display1[10:0] <= 11'b11100000111;
				else if (sensores == 4'hc) display1[10:0] <= 11'b11100010000;
				else if (sensores == 4'hd) display1[10:0] <= 11'b11100000111;
				else if (sensores == 4'he) display1[10:0] <= 11'b11100001001;
				else if (sensores == 4'hf) display1[10:0] <= 11'b11101000111;
				else display1[10:0] <= 11'b11111111111;
			default: display1[10:0] <= 11'b11111111111;				
		endcase
	end
endmodule
