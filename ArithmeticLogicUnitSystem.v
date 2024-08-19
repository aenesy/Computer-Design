`timescale 1ns / 1ps
/////////////////////////////////4///////////////////////////////////

module ArithmeticLogicUnitSystem(
    RF_OutASel, RF_OutBSel, RF_FunSel, RF_RegSel, RF_ScrSel,
    ALU_FunSel, ALU_WF, 
    ARF_OutCSel, ARF_OutDSel, ARF_FunSel, ARF_RegSel, 
    IR_LH, IR_Write, 
    Mem_WR, Mem_CS, 
    MuxASel, MuxBSel, MuxCSel, Clock); 

    //RF
    input wire [2:0] RF_OutASel, RF_OutBSel, RF_FunSel; 
    input wire [3:0] RF_RegSel, RF_ScrSel;
    wire [15:0] OutA, OutB; 
    
    //ALU
    input wire [4:0] ALU_FunSel;
    input wire ALU_WF;
    wire [15:0] ALUOut;
    wire [3:0] Flags_out;
    
    input wire [1:0] ARF_OutCSel, ARF_OutDSel; 
    input wire [2:0] ARF_FunSel, ARF_RegSel;
    wire [15:0] OutC, OutD;
    
    //IR
    input wire IR_LH;
    input wire IR_Write;
    wire [15:0] IROut;

    //Memory
    input wire Mem_WR;
    input wire Mem_CS;
    wire [15:0] Address;
    wire [7:0] MemOut;
    
    // MUX A
    input wire [1:0] MuxASel;
    wire [15:0] MuxAOut;
    
    //MUX B
    input wire [1:0] MuxBSel;
    wire [15:0] MuxBOut;
    
    //MUX C
    input wire MuxCSel;
    wire [7:0] MuxCOut;
    
    
    input wire Clock;
    assign Address = OutD;

    
    
    assign MuxCOut = (MuxCSel == 2'b0) ? ALUOut[7:0] :
                     (MuxCSel == 2'b1) ? ALUOut[15:8] : 16'b0;
    
    Memory MEM(
            .Address(Address), 
            .Data(MuxCOut), 
            .WR(Mem_WR), 
            .CS(Mem_CS), 
            .Clock(Clock), 
            .MemOut(MemOut)
        );
//module ArithmeticLogicUnit(A, B, FunSel, WF, Clock, ALUOut, FlagsOut);
        ArithmeticLogicUnit ALU(
            .A(OutA), 
            .B(OutB), 
            .FunSel(ALU_FunSel), 
            .WF(ALU_WF),
            .Clock(Clock),
            .ALUOut(ALUOut), 
            .FlagsOut(Flags_out)
        );
        
        

//        //MUXA
        assign MuxAOut = (MuxASel == 2'b00) ? ALUOut :
                         (MuxASel == 2'b01) ? OutC :
                         (MuxASel == 2'b10) ? {{8{1'b0}}, MemOut} :
                         (MuxASel == 2'b11) ? {{8{1'b0}}, IROut} : 16'b0;

//        //MUXB
        assign MuxBOut = (MuxBSel == 2'b00) ? ALUOut :
                 (MuxBSel == 2'b01) ? OutC :
                 (MuxBSel == 2'b10) ? {{8{1'b0}}, MemOut} :
                 (MuxBSel == 2'b11) ? {{8{1'b0}}, IROut} : 16'b0;
//module InstructionRegister(I, Write, LH, Clock, IROut);
        InstructionRegister IR(
            .I(MemOut),
            .Write(IR_Write),
            .LH(IR_LH),
            .Clock(Clock),
            .IROut(IROut)
        );
//module RegisterFile(I, OutASel, OutBSel, FunSel, RegSel, ScrSel, Clock, OutA, OutB);
        RegisterFile RF(
            .I(MuxAOut), 
            .OutASel(RF_OutASel), 
            .OutBSel(RF_OutBSel), 
            .FunSel(RF_FunSel), 
            .RegSel(RF_RegSel), 
            .ScrSel(RF_ScrSel), 
            .Clock(Clock),
            .OutA(OutA), 
            .OutB(OutB)
        );

//module AddressRegisterFile(I, OutCSel, OutDSel, FunSel, RegSel, Clock, OutC, OutD);        
        AddressRegisterFile ARF(
            .I(MuxBOut), 
            .OutCSel(ARF_OutCSel), 
            .OutDSel(ARF_OutDSel), 
            .FunSel(ARF_FunSel), 
            .RegSel(ARF_RegSel),
            .Clock(Clock),
            .OutC(OutC), 
            .OutD(OutD)
        );

endmodule