`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////
///////////////////////////////part1////////////////////////////
module Register(I, E, FunSel, Clock, Q);
    input wire[15:0] I;
    input wire E;
    input wire[2:0] FunSel;
    input wire Clock;
    
    output reg[15:0] Q;
    
    always @(posedge Clock) begin
        if(E == 0)
            begin 
            Q <= Q;
            end
        else
            begin
                if(FunSel == 3'b000) 
                    Q <= Q - 1;
                else if(FunSel == 3'b001) 
                    Q <= Q + 1;
                else if(FunSel == 3'b010)
                    Q <= I;
                else if(FunSel == 3'b011) 
                    Q <= 8'b0000000;
                else if(FunSel == 3'b100)
                    begin
                        Q[15:8] <= 8'b0000000;
                        Q[7:0] <= I[7:0];
                    end
                else if(FunSel == 3'b101) 
                    Q[7:0] <= I[7:0];
                else if(FunSel == 3'b110)
                    Q[15:8] <= I[7:0];
                else if(FunSel == 3'b111)
                    begin
                        Q[15] <= I[7]; 
                        Q[14:8] <= Q[15] ? 8'b11111111 : 8'b00000000; 
                        
                        Q[7:0] <= I[7:0];
                    end                 
            end
    end
endmodule
