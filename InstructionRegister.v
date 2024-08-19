`timescale 1ns / 1ps


module InstructionRegister(I, Write, LH, Clock, IROut);
	input [7:0] I;
	input Write, LH, Clock;
	
	output reg [15:0] IROut;
	
    always @(posedge Clock) begin
        if(Write == 0) IROut <= IROut;
        else begin
            if(LH == 0)
                IROut[7:0] <= I;
            else
                IROut[15:8] <= I;
        end
    end
endmodule
