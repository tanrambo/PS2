module Asignacion(
	input wire CLK_puar, restart,
	input wire [7:0] dato,
	output wire [10:0] SSD,
	output wire [2:0] leds);
	
	wire [3:0] sensores;
	wire reset, corto, gas, humo, temp, silenciar;
	
	Proyecto1 Proy1(
		.CLK_ulong(CLK_puar), .reset(reset), .sensores(sensores), .S(silenciar), .SSD(SSD), .leds(leds));

	Lol Recepcion(
		.CLK_chaos(CLK_puar), .restart(restart), .dato(dato), .sensores(sensores), .B(silenciar), .reinicio(reset));

endmodule
