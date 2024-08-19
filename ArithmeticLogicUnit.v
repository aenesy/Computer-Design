`timescale 1ns / 1ps


module ArithmeticLogicUnit(A, B, FunSel, WF, Clock, ALUOut, FlagsOut);

    input wire [15:0] A, B;
    input wire [4:0] FunSel;
    input wire WF, Clock;
    output reg [15:0] ALUOut;
    
    output reg [3:0] FlagsOut;
    
    reg  [3:0] oldFlags = 4'b0000;
    reg tmp, neg;
    reg carry_out = 0;
    reg Z = 0;
    reg C = 0;
    reg N = 0;
    reg O = 0;

    always @(*) begin
        neg <= C;
        if (FunSel >= 5'b00000 && FunSel <= 5'b01111) 
            ALUOut[15:7] = 0;
            
        Z <= FlagsOut[3];
        C <= FlagsOut[2];
        N <= FlagsOut[1];
        O <= FlagsOut[0];

        case (FunSel)
           // 8-bit operations
           5'b00000: begin //ALUOut = A(8-bit)
               ALUOut[7:0] = A[7:0];
           end
           5'b00001: begin //ALUOut = B(8-bit)
               ALUOut[7:0] = B[7:0];
           end
           5'b00010: begin //ALUOut = NOT A(8-bit)
               ALUOut[7:0] = ~A[7:0];
           end
           5'b00011: begin //ALUOut = NOT B(8-bit)
               ALUOut[7:0] = ~B[7:0];
           end
           5'b00100: begin // A + B (8-bit)
                {carry_out, ALUOut[7:0]} = {1'b0, A[7:0]} + {1'b0, B[7:0]};
           end
           5'b00101: begin // A + B + Carry (8-bit)
                {carry_out, ALUOut[7:0]} = {1'b0, A[7:0]} + {1'b0, B[7:0]} +  {8'b0, C};
           end
           5'b00110: begin // A - B (8-bit)
              {carry_out, ALUOut[7:0]} = {1'b0, A[7:0]} + {1'b0, (~B[7:0] + 8'd1)};
           end
           5'b00111: begin // A AND B (8-bit)
               ALUOut[7:0] = A[7:0] & B[7:0];
           end
           5'b01000: begin // A OR B (8-bit)
               ALUOut[7:0] = A[7:0] | B[7:0];
           end
           5'b01001: begin // A XOR B (8-bit)
               ALUOut[7:0] = A[7:0] ^ B[7:0];
           end
           5'b01010: begin // A NAND B (8-bit)
               ALUOut[7:0] = ~(A[7:0] & B[7:0]);
           end
           5'b01011: begin // LSL A (8-bit)
               ALUOut = {A[6:0], 1'b0};//ALUOut[7:0] = A[7:0] << 1;
           end
           5'b01100: begin // LSR A (8-bit)
               ALUOut = {1'b0, A[7:1]};//ALUOut[7:0] = A[7:0] >> 1;
           end
           5'b01101: begin // ASR A (8-bit)
               ALUOut = {A[7], A[7:1]};
           end
           5'b01110: begin // CSL A (8-bit)
               tmp <= A[7];
               ALUOut[7:0] <= {A[6:0], tmp};
           end
           5'b01111: begin // CSR A (8-bit)
               tmp <= A[0];
               ALUOut[7:0] = {tmp, A[7:1]};
           end
           
           
            5'b10000: begin // A (16-bit)
                ALUOut = A;
            end
            5'b10001: begin // B (16-bit)
                ALUOut = B;
                end
                5'b10010: begin // NOT A (16-bit)
                    ALUOut = ~A;
                end
                5'b10011: begin // NOT B (16-bit)
                    ALUOut = ~B;
                end
                5'b10100: begin // A + B (16-bit)
                    {carry_out, ALUOut} = {1'b0, A} + {1'b0, B};
                end
                5'b10101: begin // A + B + Carry (16-bit)
                    {carry_out, ALUOut} = {1'b0, A} + {1'b0, B} + C;
                end
                5'b10110: begin // A - B (16-bit)
                   {carry_out, ALUOut} = {1'b0, A} + {1'b0, (~B + 16'd1)};
                end
                5'b10111: begin // A AND B (16-bit)
                    ALUOut = A & B;
                end
                5'b11000: begin // A OR B (16-bit)
                    ALUOut = A | B;
                end
                5'b11001: begin // A XOR B (16-bit)
                    ALUOut = A ^ B;
                end
                5'b11010: begin // A NAND B (16-bit)
                    ALUOut = ~(A & B);
                end
                5'b11011: begin // LSL A (16-bit)
                    ALUOut = {A[14:0], 1'b0};
                end
                5'b11100: begin // LSR A (16-bit)
                    ALUOut = {1'b0, A[15:1]};
                end
                5'b11101: begin // ASR A (16-bit)
                    ALUOut = {A[15], A[15:1]};
                end
                5'b11110: begin // CSL A (16-bit)                    
                    carry_out <= A[15];
                    ALUOut <= {A[14:0], tmp};
                end
                5'b11111: begin // CSR A (16-bit)                    
                    
                       tmp <= A[0];
                                ALUOut[15:0] = {tmp, A[15:1]};
                end         
                default: begin
                    ALUOut = A; // Default to A
                end
        endcase
    end

    always @(posedge Clock) begin
        
        if (!WF) begin 
            FlagsOut <= oldFlags;
        end else begin 
            case (FunSel)
             // 8-bit operations
               5'b00000: begin //ALUOut = A(8-bit)
                   {Z, C, N, O} = {A[7:0] == 8'd0, C, A[7], O}; // Flags for A (8-bit)
               end
               5'b00001: begin //ALUOut = B(8-bit)
                   {Z, C, N, O} = {B[7:0] == 8'd0, C, B[7], O}; // Flags for B (8-bit)
               end
               5'b00010: begin //ALUOut = NOT A(8-bit)
                   {Z, C, N, O} = {~A[7:0] == 8'd0, C, ~A[7], O}; // Flags for NOT A (8-bit)
               end
               5'b00011: begin //ALUOut = NOT B(8-bit)
                   {Z, C, N, O} = {~B[7:0] == 8'd0, C, ~B[7], O}; // Flags for NOT B (8-bit)
               end
               
               5'b00100: begin // A + B (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, carry_out, ALUOut[7], ((A[7] == B[7]) && (A[7] != ALUOut[7]))}; // pos. + pos. ? neg.//neg. + neg. ? pos. 
               end
               5'b00101: begin // A + B + Carry (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, carry_out, ALUOut[7],((A[7] == B[7]) && (A[7] != ALUOut[7]))}; // pos. + pos. ? neg.//neg. + neg. ? pos. 
               end
               5'b00110: begin // A - B (8-bit)
                    {Z, C, N, O} = {ALUOut[7:0] == 8'd0, ~carry_out, ALUOut[7], A[7] != B[7] && A[7] != ALUOut[7]};//pos. - neg. ? neg.//neg. - pos. ? pos. 
               end
               
               
               5'b00111: begin // A AND B (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, C, ALUOut[7], O}; // Flags for A AND B (8-bit)
               end
               5'b01000: begin // A OR B (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, C, ALUOut[7], O}; // Flags for A OR B (8-bit)
               end
               5'b01001: begin // A XOR B (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, C, ALUOut[7], O}; // Flags for A XOR B (8-bit)
               end
               5'b01010: begin // A NAND B (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, C, ALUOut[7], O}; // Flags for A NAND B (8-bit)
               end
               
               
               5'b01011: begin // LSL A (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, A[7], ALUOut[7], O}; // Flags for LSL A (8-bit)
               end
               5'b01100: begin // LSR A (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, A[0], 1'b0, O}; // Flags for LSR A (8-bit)
               end
               5'b01101: begin // ASR A (8-bit)
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, A[0], N, O}; // Flags for ASR A (8-bit)
               end
      5'b01110: begin // CSL A (8-bit)
                   tmp <= A[7]; // Store the MSB to be moved to the LSB
                   {Z, C, N, O} = {ALUOut[7:0] == 8'd0, A[7], A[6], O}; // Flags for CSL A (8-bit)
                 
               end

            5'b01111: begin // CSR A (8-bit)
    tmp <= A[0]; // Store the LSB to be moved to the MSB
    {Z, C, N, O} = {ALUOut[7:0] == 8'd0, A[0], A[7], O}; // Flags for CSR A (8-bit)
  
end

                // 16-bit operations
                5'b10000: begin // A (16-bit)
                    {Z, C, N, O} = {A == 16'd0, C, A[15], O}; // Flags for A (16-bit)
                end
                5'b10001: begin // B (16-bit)
                    {Z, C, N, O} = {B == 16'd0, C, B[15], O};
                end
                5'b10010: begin // NOT A (16-bit)
                    {Z, C, N, O} = {~A == 16'd0, C, ~A[15], O}; // Flags for NOT A (16-bit)
                end
                5'b10011: begin // NOT B (16-bit)
                    {Z, C, N, O} = {~B == 16'd0, C, ~B[15], O}; // Flags for NOT B (16-bit)
                end
                
                
                5'b10100: begin // A + B (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, carry_out, ALUOut[15], A[15] == B[15] && A[15] != ALUOut[15]}; // Flags for A + B (16-bit)
                end
                5'b10101: begin // A + B + Carry (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, carry_out, ALUOut[15], A[15] == B[15] && A[15] != ALUOut[15]}; // Flags for A + B + Carry (16-bit)
                end
                5'b10110: begin // A - B (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, ~carry_out, ALUOut[15], A[15] != B[15] && A[15] != ALUOut[15]}; // Flags for A - B (16-bit)
                end
                
                
                5'b10111: begin // A AND B (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, C, ALUOut[15], O}; // Flags for A AND B (16-bit)
                end
                5'b11000: begin // A OR B (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, C, ALUOut[15], O}; // Flags for A OR B (16-bit)
                end
                5'b11001: begin // A XOR B (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, C, ALUOut[15], O}; // Flags for A XOR B (16-bit)
                end
                5'b11010: begin // A NAND B (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, C, ALUOut[15], O}; // Flags for A NAND B (16-bit)
                end
                
                5'b11011: begin // LSL A (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, A[15], ALUOut[15], O}; // Flags for LSL A (16-bit)
                end
                5'b11100: begin // LSR A (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, A[0], 1'b0, O}; // Flags for LSR A (16-bit)
                end
                5'b11101: begin // ASR A (16-bit)
                    {Z, C, N, O} = {ALUOut == 16'd0, A[0], N, O}; // Flags for ASR A (16-bit)
                end
                5'b11110: begin // CSL A (16-bit)
                    tmp <= C;
                    {Z, C, N, O} = {ALUOut == 16'd0, carry_out, A[14], O}; // Flags for CSL A (16-bit)
                end
                5'b11111: begin // CSR A (16-bit)
                    tmp <= C;
                    {Z, C, N, O} = {ALUOut == 16'd0, tmp, neg, O}; // Flags for CSR A (16-bit)
                end
                default: begin
                    {Z, C, N, O} = {A == 16'd0, C, N, O}; // Default flags for A (16-bit)
                end
            endcase
        
            FlagsOut <= {Z, C, N, O};
            oldFlags <= {Z, C, N, O}; 
            
        end
    end
endmodule

