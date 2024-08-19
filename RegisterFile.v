`timescale 1ns / 1ps

module RegisterFile(I, OutASel, OutBSel, FunSel, RegSel, ScrSel, Clock, OutA, OutB);
    input wire [15:0] I;
    input wire [2:0] OutASel, OutBSel;
    input wire [2:0] FunSel;
    input wire [3:0] RegSel, ScrSel;
    input wire Clock;
    
    output reg [15:0] OutA, OutB;
    
    wire ENR1,ENR2,ENR3,ENR4,ENS1,ENS2,ENS3,ENS4;
    
    wire [15:0] QR1, QR2, QR3, QR4, QS1, QS2, QS3, QS4;
        
    assign {ENR1,ENR2,ENR3,ENR4} = ~RegSel;
    assign {ENS1,ENS2,ENS3,ENS4} = ~ScrSel;
    
    //Register(I, E, FunSel, Clock, Q)
    Register R1 (.I(I), .E(ENR1), .FunSel(FunSel), .Clock(Clock), .Q(QR1));
    Register R2 (.I(I), .E(ENR2), .FunSel(FunSel), .Clock(Clock), .Q(QR2));
    Register R3 (.I(I), .E(ENR3), .FunSel(FunSel), .Clock(Clock), .Q(QR3));
    Register R4 (.I(I), .E(ENR4), .FunSel(FunSel), .Clock(Clock), .Q(QR4));
    
    Register S1 (.I(I), .E(ENS1), .FunSel(FunSel), .Clock(Clock), .Q(QS1));
    Register S2 (.I(I), .E(ENS2), .FunSel(FunSel), .Clock(Clock), .Q(QS2));
    Register S3 (.I(I), .E(ENS3), .FunSel(FunSel), .Clock(Clock), .Q(QS3));
    Register S4 (.I(I), .E(ENS4), .FunSel(FunSel), .Clock(Clock), .Q(QS4));
    
    always @(*) begin
        case (OutASel)
            3'b000: OutA <= QR1;
            3'b001: OutA <= QR2;
            3'b010: OutA <= QR3;
            3'b011: OutA <= QR4;
            3'b100: OutA <= QS1;
            3'b101: OutA <= QS2;
            3'b110: OutA <= QS3;
            3'b111: OutA <= QS4;
        endcase
        case (OutBSel)
            3'b000: OutB <= QR1;
            3'b001: OutB <= QR2;
            3'b010: OutB <= QR3;
            3'b011: OutB <= QR4;
            3'b100: OutB <= QS1;
            3'b101: OutB <= QS2;
            3'b110: OutB <= QS3;
            3'b111: OutB <= QS4;
        endcase
    end
    
endmodule

