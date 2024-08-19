`timescale 1ns / 1ps

//////////////////////2-c////////////////////////////
//AddressRegisterFile ARF(.I(I), .OutCSel(OutCSel), .OutDSel(OutDSel), .FunSel(FunSel), .RegSel(RegSel), .Clock(clk.clock), .OutC(OutC), .OutD(OutD));
module AddressRegisterFile(I, OutCSel, OutDSel, FunSel, RegSel, Clock, OutC, OutD);
    input wire [15:0] I;
    input wire [1:0] OutCSel, OutDSel;
    input wire [2:0] FunSel, RegSel;
    input wire Clock;
    output reg [15:0] OutC, OutD;
    
    wire E1,E2,E3;
    
    wire [15:0] QPC, QAR, QSP;
    
                
    assign {EPC,EAR,ESP} = ~RegSel;
    // Register(I, E, FunSel, Clock, Q)
    Register PC (.I(I), .E(EPC), .FunSel(FunSel), .Clock(Clock), .Q(QPC));
    Register AR (.I(I), .E(EAR), .FunSel(FunSel), .Clock(Clock), .Q(QAR));
    Register SP (.I(I), .E(ESP), .FunSel(FunSel), .Clock(Clock), .Q(QSP));
 
    
    always @(*) begin
        case (OutCSel)
            2'b00: OutC <= QPC;
            2'b01: OutC <= QPC;
            2'b10: OutC <= QAR;
            2'b11: OutC <= QSP;
        endcase
        case (OutDSel)
            2'b00: OutD <= QPC;
            2'b01: OutD <= QPC;
            2'b10: OutD <= QAR;
            2'b11: OutD <= QSP;
        endcase
    end
    
endmodule
