`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2024 08:24:36
// Design Name: 
// Module Name: CLA_inter
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


module CLA_inter#(
    parameter   ADDER_WIDTH = 8
    )
    (
    input   wire [ADDER_WIDTH-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [ADDER_WIDTH-1:0]  oSum, 
    output  wire                    oCarry
);

    wire [ADDER_WIDTH-1:0] oSum0,oSum1;
    wire c0,c1;
    // solve the sum and carry assuming the carry is 1 and 0

     CLA_first
     #( .ADDER_WIDTH(ADDER_WIDTH) ) carry1
     (
    .iA(iA[ADDER_WIDTH-1:0]),
    .iB(iB[ADDER_WIDTH-1:0]),
    .iCarry(1'b1),
    .oSum(oSum1[ADDER_WIDTH-1:0]),
    .oCarry(c1));
    
    CLA_first
    #( .ADDER_WIDTH(ADDER_WIDTH) )  carry0
    (
    .iA(iA[ADDER_WIDTH-1:0]),
    .iB(iB[ADDER_WIDTH-1:0]),
    .iCarry(1'b0),
    .oSum(oSum0[ADDER_WIDTH-1:0]),
    .oCarry(c0));

     // here select the sum and carry based on the iCarry, in the lecture a multiplexer was used but we don't need it
    
      assign oSum = (iCarry) ? oSum1 : oSum0;
      assign oCarry = (iCarry) ? c1 : c0;
endmodule
