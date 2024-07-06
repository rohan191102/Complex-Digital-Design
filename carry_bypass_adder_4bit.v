`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 02:42:55
// Design Name: 
// Module Name: carry_bypass_adder_4bit
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


module carry_bypass_adder_4bit(
    input [3:0] A,
    input [3:0] B,
    input cin,
    output [3:0] sum,
    output cout
);

wire [3:0] c_out;
wire [3:0] s_wire;

carry_bypass_adder_2bit cba_inst0 (
    .A(A[1:0]),
    .B(B[1:0]),
    .cin(cin),
    .sum(sum[1:0]),
    .cout(c_out[1])
);
carry_bypass_adder_2bit cba_inst1 (
    .A(A[3:2]),
    .B(B[3:2]),
    .cin(c_out[1]),
    .sum(sum[3:2]),
    .cout(cout)
);

endmodule

