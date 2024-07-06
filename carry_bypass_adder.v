`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.04.2024 21:38:53
// Design Name: 
// Module Name: carry_bypass_adder
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


module carry_bypass_adder
#(
    parameter ADDER_WIDTH = 32
)
(
    input [ADDER_WIDTH-1:0] iA, iB,
    input iCarry,
    output [ADDER_WIDTH-1:0] oSum,
    output oCarry
);
    wire [ADDER_WIDTH-1:0] p;
    wire c0;
    wire bp;
    
    ripple_carry_adder_Nb #(.ADDER_WIDTH(ADDER_WIDTH)) rca1 (.iA(iA), .iB(iB), .iCarry(iCarry), .oSum(oSum), .oCarry(c0));
    generate_p #(.ADDER_WIDTH(ADDER_WIDTH)) p1 (.a(iA), .b(iB), .p(p), .bp(bp));
    mux2X1 #(.width(1)) m0 (.iA(c0), .iB(iCarry), .iSel(bp), .oOut(oCarry));
endmodule

