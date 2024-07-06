`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2024 08:24:18
// Design Name: 
// Module Name: CLA_first
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


module CLA_first
 #(
    parameter   ADDER_WIDTH = 8 // now we are in the block
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
);
    wire[ADDER_WIDTH:0] carry;
    wire[ADDER_WIDTH-1:0] propagate;
    wire[ADDER_WIDTH-1:0] Generate;
    
    
    genvar i;
    generate
        for (i = 0; i < ADDER_WIDTH; i = i + 1) 
        begin
        PFA partial_inst
        (
            .iA(iA[i]),
            .iB(iB[i]),
            .iCarry(carry[i]),
            .oSum(oSum[i]),
            .propagate(propagate[i]),
            .Generate(Generate[i])
        );
        end 
        
        endgenerate
    
assign carry[0] = iCarry;
generate
    for (i = 1; i <= ADDER_WIDTH; i=i+1) begin: carryThings
        assign something = propagate[i-1] & carry[i-1]; // from lecture
        assign carry[i] = Generate[i-1] | something; // from lecture
    end
    endgenerate


assign oCarry= carry[ADDER_WIDTH];

endmodule
