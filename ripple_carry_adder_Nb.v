`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2024 16:47:43
// Design Name: 
// Module Name: ripple_carry_adder_Nb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ripple_carry_adder_Nb#(
    parameter   ADDER_WIDTH = 16
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
    );
    
    wire[ADDER_WIDTH-1:0] iC;
    
    full_adder full_adder_inst1(.iA(iA[0]),.iB(iB[0]),.iCarry(iCarry),.oSum(oSum[0]),.oCarry(iC[0]));
    genvar i;
    
    generate
        for (i=1; i<ADDER_WIDTH; i=i+1) 
        begin
        full_adder full_adder_inst (
            .iA(iA[i]),
            .iB(iB[i]),
            .oSum(oSum[i]),
            .iCarry(iC[i-1]),
            .oCarry(iC[i])
        );
        end 
    endgenerate
    
    assign oCarry = iC[ADDER_WIDTH-1];
    
endmodule

