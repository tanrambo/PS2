`timescale 1ns / 1ps

module Proyecto2(
	input wire CLK_yamsha, reset, ps2_c, ps2_d,
	output wire [10:0] display,
	output wire [2:0] leds,
	output wire vacio
	);
		 
	wire [7:0] bus;
	wire n_tick, bandera;
	reg [7:0] dout;
	reg rx_en;


	DataReceiver ps2rx(
		.clk(CLK_yamsha), .reset(reset), .ps2d(ps2_d), .ps2c(ps2_c), .rx_en(rx_en), .dout(bus), .vacio(vacio));
	
	Asignacion FSM(
		.CLK_puar(CLK_yamsha), .restart(reset), .dato(bus), .SSD(display), .leds(leds));

	always @ (posedge n_tick, posedge reset) begin
		if(reset) begin 
			rx_en <= 1'b1;
		end
	end

endmodule