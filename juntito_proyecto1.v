`timescale 1ns / 1ps

module Proyecto1(
	input wire CLK_ulong, reset, S,
	input wire [3:0] sensores,
	output wire [10:0] SSD,
	output wire [2:0] leds);
	 
	wire [2:0] estado;
	wire clk7, clkmp;
	
   Maquina_FSM FSM(
		.CLK_ROSHI(CLK_ulong), .reset(reset), .sensores(sensores), .silenciar(S),
		.Z(leds), .state(estado));

	Maq_7seg SeSeDi(
		.clk(CLK_ulong), .estado(estado), .sensores(sensores), .display1(SSD));
		
	/*Divisor7Seg Frec(
		.clk(CLK_ulong), .clk_out(clk7));
		
	Divisor FrecFSM(
		.clk(CLK_ulong), .clk_out(clkmp));*/
	
endmodule
