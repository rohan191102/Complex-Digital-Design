`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 02:42:22
// Design Name: 
// Module Name: carry_bypass_adder_8bit
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


module carry_bypass_adder_8bit(
    input [7:0] A,
    input [7:0] B,
    input cin,
    output [7:0] sum,
    output cout
);

wire [7:0] c_out;
wire [7:0] s_wire;

// Instantiate two 4-bit carry bypass adders
carry_bypass_adder_4bit cba_inst0 (
    .A(A[3:0]),
    .B(B[3:0]),
    .cin(cin),
    .sum(sum[3:0]),
    .cout(c_out[3])
);
carry_bypass_adder_4bit cba_inst1 (
    .A(A[7:4]),
    .B(B[7:4]),
    .cin(c_out[3]),
    .sum(sum[7:4]),
    .cout(cout)
);

endmodule

