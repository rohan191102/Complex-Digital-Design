`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2024 08:28:53
// Design Name: 
// Module Name: PFA
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


module PFA(
    input   wire    iA, 
    input wire iB, 
    input wire iCarry,
    output  wire oSum, 
    output wire Generate,
    output wire propagate
    );
    // Lecture things about the partial adder in lecture 3
    assign oSum = iA ^ iB ^ iCarry;
    assign propagate = iA|iB ;
    assign Generate = iA & iB ;
    
endmodule
