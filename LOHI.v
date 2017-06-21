`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:28:49 06/21/2017 
// Design Name: 
// Module Name:    LOHI
//
//////////////////////////////////////////////////////////////////////////////////
module LOHI(
	input clk		,
	input [31:0] wLO,
	input [31:0] wHI,
	input [1: 0] wen,		//дʹ�ܾ����洢LO����HI
	output [31:0] rLO,				//����LO��ֵ
	output [31:0] rHI				//����HI��ֵ
    );
	reg [31:0] HI;
	reg [31:0] LO;

	assign rLO = LO;
	assign rHI = HI;

	always @(posedge clk)
	begin
		if(wen == 2'b11)
		begin
			HI <= wHI;
			LO <= wLO;
		end

		if(wen == 2'b01)
		begin
			LO <= wLO;
		end

		if(wen == 2'b10)
		begin
			HI <= wHI;
		end		
	end


endmodule
