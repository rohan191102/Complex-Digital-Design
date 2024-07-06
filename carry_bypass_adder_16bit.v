`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 02:41:37
// Design Name: 
// Module Name: carry_bypass_adder_16bit
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


module carry_bypass_adder_16bit(
    input [15:0] A,
    input [15:0] B,
    input cin,
    output [15:0] sum,
    output oCarry
);

wire [15:0] c_out;
wire [15:0] s_wire;

// Instantiate two 8-bit carry bypass adders
carry_bypass_adder_8bit cba_inst0 (
    .A(A[7:0]),
    .B(B[7:0]),
    .cin(cin),
    .sum(sum[7:0]),
    .cout(c_out[7])
);
carry_bypass_adder_8bit cba_inst1 (
    .A(A[15:8]),
    .B(B[15:8]),
    .cin(c_out[7]),
    .sum(sum[15:8]),
    .cout(cout)
);

endmodule

